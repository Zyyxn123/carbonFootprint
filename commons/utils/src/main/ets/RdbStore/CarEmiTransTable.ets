import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { CarbonMsgSQLConstants } from '../Constants/CarbonMsgSQL';
import { CarEmiTransLogger } from '../Hilog/HilogInfo';
import { TransItemDataType, TransTotalDataType } from '../Interface/TransDataType';
import { CarbonMsgDBManager } from './CarbonMsgDBManager';

export class CarEmiTransTable {
  private static instance: CarEmiTransTable
  private readonly transItemName: string = 'transListTable'
  private readonly transTotalName: string = 'transTotalTable'
  public transStore: relationalStore.RdbStore | undefined = undefined
  private DBManager: CarbonMsgDBManager = CarbonMsgDBManager.getInstance()

  public static getInstance(): CarEmiTransTable {
    if (!CarEmiTransTable.instance) {
      CarEmiTransTable.instance = new CarEmiTransTable()
    }
    return CarEmiTransTable.instance
  }

  public async initTable() {
    if (this.DBManager.carbonMsgRdbStore === undefined) {
      CarEmiTransLogger.error('数据库创建失败')
      return
    }
    this.transStore = this.DBManager.carbonMsgRdbStore

    try {
      await this.transStore.execute(CarbonMsgSQLConstants.createTransItemSQL(this.transItemName))
      CarEmiTransLogger.info('Item表创建成功')
    } catch (error) {
      CarEmiTransLogger.error('Item表创建失败：' + error)
    }

    try {
      await this.transStore.execute(CarbonMsgSQLConstants.createTransTotalSQL(this.transTotalName))
      CarEmiTransLogger.info('Total表创建成功')
    } catch (error) {
      CarEmiTransLogger.error('Total表创建失败：' + error)
    }
  }

  /**
   * 删除两个表：Total Item
   */
  public async deleteMyTable() {
    if (!this.transStore) {
      CarEmiTransLogger.error('数据库创建失败')
      return
    }
    try {
      await this.transStore.execute(CarbonMsgSQLConstants.deleteTableSQL(this.transItemName))
      CarEmiTransLogger.info('Item表删除成功')
    } catch (error) {
      CarEmiTransLogger.error('Item表删除失败：' + error)
    }

    try {
      await this.transStore.execute(CarbonMsgSQLConstants.deleteTableSQL(this.transTotalName))
      CarEmiTransLogger.info('Total表删除成功')
    } catch (error) {
      CarEmiTransLogger.error('Total表删除失败：' + error)
    }
  }

  /**
   * 记录用户每次外出行为的数据
   * @param acc：账号
   * @param transport：交通方式
   * @param mileage：行驶里程
   * @param trip_time：行驶时间
   * @param time_token：登记时间
   * @param carbon_emission：碳排放量
   */
  public async insertItemData(acc: string, transport: string, mileage: number,
    trip_time: number, time_token: string, carbon_emission: number) {
    if (!this.transStore) {
      CarEmiTransLogger.error('数据库创建失败')
      return
    }
    let valueBucket: relationalStore.ValuesBucket = {
      ACCOUNT: acc,
      TRANSPORT: transport,
      MILEAGE: mileage,
      TRIP_TIME: trip_time,
      TIME_TOKEN: time_token,
      CARBON_EMISSION: carbon_emission,
    }
    this.transStore.insert(this.transItemName, valueBucket,
      (err: BusinessError, rowId: number) => {
        if (err) {
          CarEmiTransLogger.error(acc + ' Item插入数据失败：' +
            `Insert is failed, code is ${err.code},message is ${err.message}`)
        }
        CarEmiTransLogger.info(acc + ' Item插入数据成功' + `rowId:${rowId}: ` +
          `account=${acc}, transport=${transport}, mileage=${mileage}, trip_time=${trip_time},
      time_token=${time_token}, carbon_emission=${carbon_emission}`)
      })
  }

  /**
   * 新建用户时初始化交通出行的总数据
   * @param acc：账号
   */
  public async setOriginalTotalData(acc: string) {
    if (!this.transStore) {
      CarEmiTransLogger.error('数据库创建失败')
      return
    }
    let date: Date = new Date()
    const valueBucket: relationalStore.ValuesBucket = {
      ACCOUNT: acc,
      TOTAL_EMISSION: 0.0,
      TOTAL_DAY: 0,
      MONTHLY_EMISSION: 0.0,
      MONTHLY_ORDER: 0,
      MONTHLY_DISTANCE: 0.0,
      POINT: 0,
      MEDAL: 0,
      TIME_TOKEN: '1/1/1999'
    }
    try {
      const rowId = await this.transStore.insert(this.transTotalName, valueBucket)
      CarEmiTransLogger.info(acc + 'Total初始化数据成功：' + `rowId:${rowId}`)
    } catch (error) {
      CarEmiTransLogger.error(acc + 'Total初始化数据失败：' + error)
    }
  }

  public async getTransItemData(acc: string): Promise<TransItemDataType[]> {
    let resultItem: TransItemDataType[] = []

    return new Promise((resolve) => {
      if (!this.transStore) {
        CarEmiTransLogger.error('数据库创建失败')
        resolve(resultItem)
        return
      }

      const predicates = new relationalStore.RdbPredicates(this.transItemName)
      predicates.equalTo('ACCOUNT', acc)

      this.transStore.query(predicates,
        ['USER_ID', 'ACCOUNT', 'TRANSPORT', 'MILEAGE', 'TRIP_TIME', 'TIME_TOKEN', 'CARBON_EMISSION'],
        (err: BusinessError, resultSet) => {
          if (err) {
            CarEmiTransLogger.error('Item表查询失败：' + `code=${err.code},message=${err.message}`)
            resultSet?.close()
            resolve(resultItem)
            return
          }

          try {
            while (resultSet.goToNextRow()) {
              const id = resultSet.getLong(resultSet.getColumnIndex('USER_ID'))
              const account = resultSet.getString(resultSet.getColumnIndex('ACCOUNT'))
              const transport = resultSet.getString(resultSet.getColumnIndex('TRANSPORT'))
              const mileage = resultSet.getDouble(resultSet.getColumnIndex('MILEAGE'))
              const trip_time = resultSet.getLong(resultSet.getColumnIndex('TRIP_TIME'))
              const time_token = resultSet.getString(resultSet.getColumnIndex('TIME_TOKEN'))
              const carbon_emission = resultSet.getDouble(resultSet.getColumnIndex('CARBON_EMISSION'))

              const item: TransItemDataType = {
                id: id,
                account: account,
                transport: transport,
                mileage: mileage,
                trip_time: trip_time,
                time_token: time_token,
                carbon_emission: carbon_emission
              }

              resultItem.push(item)
              CarEmiTransLogger.info('查询到Item数据：' + JSON.stringify(item))
            }
          } catch (error) {
            CarEmiTransLogger.error('Item表遍历数据失败：' + error)
          } finally {
            resultSet.close()
          }
          CarEmiTransLogger.info(acc + ' 查询到Item总条数：' + resultItem.length)
          resolve(resultItem)
        })
    })
  }

  /**
   * 用户登录时返回总数据，供给 UI 渲染页面
   * @param acc：账号
   * @returns：返回总数据对象
   */
  public async getTransTotalData(acc: string): Promise<TransTotalDataType> {
    let resultItem: TransTotalDataType = {
      id: -1,
      account: '',
      total_emission: 0,
      total_day: 0,
      monthly_emission: 0,
      monthly_order: 0,
      monthly_distance: 0,
      point: 0,
      medal: 0,
      time_token: ''
    }

    return new Promise((resolve) => {
      if (!this.transStore) {
        CarEmiTransLogger.error('数据库创建失败')
        resolve(resultItem)
        return
      }
      const predicates2 = new relationalStore.RdbPredicates(this.transTotalName)
      predicates2.equalTo('ACCOUNT', acc)

      this.transStore.query(predicates2,
        ['USER_ID', 'ACCOUNT', 'TOTAL_EMISSION', 'TOTAL_DAY', 'MONTHLY_EMISSION',
          'MONTHLY_ORDER', 'MONTHLY_DISTANCE', 'POINT', 'MEDAL', 'TIME_TOKEN'],
        (err: BusinessError, resultSet) => {
          if (err) {
            CarEmiTransLogger.error('查询失败1：' + `code is ${err.code},message is ${err.message}`)
            resultSet?.close()
            resolve(resultItem)
            return
          }

          let isExist = false

          try {
            while (resultSet.goToNextRow()) {
              const id = resultSet.getLong(resultSet.getColumnIndex('USER_ID'))
              const total_emission = resultSet.getDouble(resultSet.getColumnIndex('TOTAL_EMISSION'))
              const total_day = resultSet.getLong(resultSet.getColumnIndex('TOTAL_DAY'))
              const monthly_emission = resultSet.getDouble(resultSet.getColumnIndex('MONTHLY_EMISSION'))
              const monthly_order = resultSet.getLong(resultSet.getColumnIndex('MONTHLY_ORDER'))
              const monthly_distance = resultSet.getDouble(resultSet.getColumnIndex('MONTHLY_DISTANCE'))
              const point = resultSet.getLong(resultSet.getColumnIndex('POINT'))
              const medal = resultSet.getLong(resultSet.getColumnIndex('MEDAL'))
              const account = resultSet.getString(resultSet.getColumnIndex('ACCOUNT'))
              const time_token = resultSet.getString(resultSet.getColumnIndex('TIME_TOKEN'))
              // resultSet.getString(resultSet.getColumnIndex('TIME_TOKEN'))
              if (account === acc) {
                resultItem.id = id
                resultItem.total_emission = total_emission
                resultItem.total_day = total_day
                resultItem.monthly_emission = monthly_emission
                resultItem.monthly_order = monthly_order
                resultItem.monthly_distance = monthly_distance
                resultItem.point = point
                resultItem.medal = medal
                resultItem.account = account
                resultItem.time_token = time_token
                CarEmiTransLogger.info('找到指定账户：' +
                  `id=${id}, account=${account}, total_emission=${total_emission},
                  total_day=${total_day}, monthly_emission=${monthly_emission}, monthly_order=${monthly_order},
                  monthly_distance=${monthly_distance}, point=${point}, medal=${medal},
                  time_token=${time_token}`)
                isExist = true
                break
              }
            }
          } catch (error) {
            CarEmiTransLogger.error('查询失败2：' + error)
            isExist = false
          } finally {
            resultSet.close()
          }
          if (isExist) {
            resolve(resultItem)
          } else {
            CarEmiTransLogger.info('未找到该用户，可以创建为新用户')
            resolve(resultItem)
          }
        })
    })
  }

  /**
   * 更新总数据
   * @param acc：账号
   */
  public async updateTotalData(data: TransTotalDataType) {
    if (!this.transStore) {
      CarEmiTransLogger.error('数据库创建失败')
      return
    }
    const valueBucket2: relationalStore.ValuesBucket = {
      ACCOUNT: data.account,
      TOTAL_EMISSION: data.total_emission,
      TIME_TOKEN: data.time_token,
      TOTAL_DAY: data.total_day,
      MONTHLY_EMISSION: data.monthly_emission,
      MONTHLY_ORDER: data.monthly_order,
      MONTHLY_DISTANCE: data.monthly_distance,
      POINT: data.point,
      MEDAL: data.medal,
    }

    let predicates1 = new relationalStore.RdbPredicates(this.transTotalName)
    predicates1.equalTo('ACCOUNT', data.account)

    this.transStore.update(valueBucket2, predicates1,
      (err: BusinessError, rows: number) => {
      if (err) {
        CarEmiTransLogger.error('Total更新失败: ' + `code is ${err.code},message is ${err.message}`)
      }
      CarEmiTransLogger.info('Total更新成功: ' + `rows:${rows};` +
        `id=${data.id}, account=${data.account}, total_emission=${data.total_emission},
         total_day=${data.total_day}, monthly_emission=${data.monthly_emission}, monthly_order=${data.monthly_order},
         monthly_distance=${data.monthly_distance}, point=${data.point}, medal=${data.medal},
         time_token=${data.time_token}`)
    })
  }
}