import { TendMapFootLogger } from "../Hilog/HilogInfo"
import { relationalStore } from "@kit.ArkData"
import { TendencyDBManager } from "./TendencyDBManager"
import { TendencySQL } from "../Constants/TendencySQL"
import { MapFootDataType } from "../Interface/MapFootDataType"

export class TendMapFootTable {
  private static instance: TendMapFootTable
  private readonly tendMapFootTableName: string = 'tendMapFootTable'
  public tendMapFootStore: relationalStore.RdbStore | undefined = undefined
  private DBManager: TendencyDBManager = TendencyDBManager.getInstance()

  public static getInstance(): TendMapFootTable {
    if (!TendMapFootTable.instance) {
      TendMapFootTable.instance = new TendMapFootTable()
    }
    return TendMapFootTable.instance
  }

  public async initTable() {
    if (this.DBManager.tendencyRdbStore === undefined) {
      TendMapFootLogger.error('111数据库创建失败')
      return
    }
    this.tendMapFootStore = this.DBManager.tendencyRdbStore

    try {
      await this.tendMapFootStore.execute(TendencySQL.createMapFootSQL(this.tendMapFootTableName))
      TendMapFootLogger.info('表创建成功')
    } catch (error) {
      TendMapFootLogger.error('表创建失败：' + error)
    }
  }

  public async deleteMyTable() {
    if (!this.tendMapFootStore) {
      TendMapFootLogger.error('222数据库创建失败')
      return
    }
    try {
      await this.tendMapFootStore.execute(TendencySQL.deleteTasksTableSQL(this.tendMapFootTableName))
      TendMapFootLogger.info('表删除成功')
    } catch (error) {
      TendMapFootLogger.error('表删除失败：' + error)
    }
  }

  public async insertItemData(acc: string, recordDate: string,
    data: string, extraData: string, carEmi: number) {
    if (!this.tendMapFootStore) {
      TendMapFootLogger.error('数据库创建失败')
      return
    }

    let valueBucket: relationalStore.ValuesBucket = {
      account: acc,
      recordDate: recordDate,
      myData: data,
      carEmi: carEmi || 0,
      extraData: extraData,
    }

    this.tendMapFootStore.insert(this.tendMapFootTableName, valueBucket,
      (err: BusinessError, rowId: number) => {
        if (err) {
          TendMapFootLogger.error(acc + ' Item插入数据失败：' + `rowId:${rowId}: ` +
            `Insert is failed, code is ${err.code},message is ${err.message},
             account=${acc},
             recordDate=${recordDate},
             data=${data},
             extraData=${extraData},
             carEmi=${carEmi}`)
          return
        }
        TendMapFootLogger.info(acc + ' Item插入数据成功' + `rowId:${rowId}: ` +
          `account=${acc}, recordDate=${recordDate}, data=${data}
          , extraData=${extraData}, carEmi=${carEmi}`)
      })
  }

  public async getItemData(acc: string): Promise<MapFootDataType[]> {
    let resultItem: MapFootDataType[] = []

    return new Promise((resolve) => {
      if (!this.tendMapFootStore) {
        TendMapFootLogger.error('数据库创建失败')
        resolve(resultItem)
        return
      }

      const predicates = new relationalStore.RdbPredicates(this.tendMapFootTableName)
      predicates.equalTo('account', acc)

      this.tendMapFootStore.query(predicates,
        ['id', 'account', 'recordDate', 'myData', 'carEmi', 'extraData'],
        (err: BusinessError, resultSet) => {
          if (err) {
            TendMapFootLogger.error('地图Item查询失败：' + `code=${err.code},message=${err.message}`)
            resultSet?.close()
            resolve(resultItem)
            return
          }

          try {
            while (resultSet.goToNextRow()) {
              const id = resultSet.getLong(resultSet.getColumnIndex('id'))
              const carEmi = resultSet.getLong(resultSet.getColumnIndex('carEmi'))
              const account = resultSet.getString(resultSet.getColumnIndex('account'))
              const recordDate = resultSet.getString(resultSet.getColumnIndex('recordDate'))
              const data = resultSet.getString(resultSet.getColumnIndex('myData'))
              const extraData = resultSet.getString(resultSet.getColumnIndex('extraData'))

              const item: MapFootDataType = {
                id: id,
                account: account,
                recordDate: recordDate,
                data: data,
                extraData: extraData,
                carEmi: carEmi,
              }
              resultItem.push(item)
              TendMapFootLogger.info('查询到地图Item：' + JSON.stringify(item))
            }
          } catch (error) {
            TendMapFootLogger.error('地图Item遍历失败：' + error)
          } finally {
            resultSet.close()
          }
          TendMapFootLogger.info(acc + ' 地图Item总条数：' + resultItem.length)
          resolve(resultItem)
        })
    })
  }
}