import { CarbonMsgDBManager } from "./CarbonMsgDBManager"
import { relationalStore } from "@kit.ArkData"
import { CarbonMsgSQLConstants } from "../Constants/CarbonMsgSQL"
import { CarEmiFoodLogger } from "../Hilog/HilogInfo"
import { FoodTotalDataType } from "../Interface/FoodDataType"

export class CarEmiFoodTable {
  private static instance: CarEmiFoodTable
  private readonly foodItemName: string = 'foodListTable'
  private readonly foodTotalName: string = 'foodTotalTable'
  public foodStore: relationalStore.RdbStore | undefined = undefined
  private DBManager: CarbonMsgDBManager = CarbonMsgDBManager.getInstance()

  public static getInstance(): CarEmiFoodTable {
    if (!CarEmiFoodTable.instance) {
      CarEmiFoodTable.instance = new CarEmiFoodTable()
    }
    return CarEmiFoodTable.instance
  }

  public async initTable() {
    if (this.DBManager.carbonMsgRdbStore === undefined) {
      CarEmiFoodLogger.error('数据库创建失败')
      return
    }
    this.foodStore = this.DBManager.carbonMsgRdbStore

    try {
      await this.foodStore.execute(CarbonMsgSQLConstants.createFoodItemSQL(this.foodItemName))
      CarEmiFoodLogger.info('Item表创建成功')
    } catch (error) {
      CarEmiFoodLogger.error('Item表创建失败：' + error)
    }

    try {
      await this.foodStore.execute(CarbonMsgSQLConstants.createFoodTotalSQL(this.foodTotalName))
      CarEmiFoodLogger.info('Total表创建成功')
    } catch (error) {
      CarEmiFoodLogger.error('Total表创建失败：' + error)
    }
  }

  /**
   * 删除两个表：Total Item
   */
  public async deleteMyTable() {
    if (!this.foodStore) {
      CarEmiFoodLogger.error('数据库创建失败')
      return
    }
    try {
      await this.foodStore.execute(CarbonMsgSQLConstants.deleteTableSQL(this.foodItemName))
      CarEmiFoodLogger.info('Item表删除成功')
    } catch (error) {
      CarEmiFoodLogger.error('Item表删除失败：' + error)
    }

    try {
      await this.foodStore.execute(CarbonMsgSQLConstants.deleteTableSQL(this.foodTotalName))
      CarEmiFoodLogger.info('Total表删除成功')
    } catch (error) {
      CarEmiFoodLogger.error('Total表删除失败：' + error)
    }
  }

  /**
   * 记录用户每次外出行为的数据
   * @param acc：账号
   * @param food：食物方式
   * @param eat_portion：食物份量
   * @param eat_time：吃饭时间
   * @param time_token：登记时间
   * @param carbon_emission：碳排放量
   */
  public async insertItemData(acc: string, food: string, eat_portion: number,
    eat_time: number, time_token: string, carbon_emission: number) {
    if (!this.foodStore) {
      CarEmiFoodLogger.error('数据库创建失败')
      return
    }
    let valueBucket: relationalStore.ValuesBucket = {
      ACCOUNT: acc,
      FOOD: food,
      EAT_PORTION: eat_portion,
      EAT_TIME: eat_time,
      TIME_TOKEN: time_token,
      CARBON_EMISSION: carbon_emission,
    }
    this.foodStore.insert(this.foodItemName, valueBucket,
      (err: BusinessError, rowId: number) => {
        if (err) {
          CarEmiFoodLogger.error(acc + ' Item插入数据失败：' +
            `Insert is failed, code is ${err.code},message is ${err.message}`)
        }
        CarEmiFoodLogger.info(acc + ' Item插入数据成功' + `rowId:${rowId}: ` +
          `account=${acc}, food=${food}, eat_portion=${eat_portion}, eat_time=${eat_time},
      time_token=${time_token}, carbon_emission=${carbon_emission}`)
      })
  }

  /**
   * 新建用户时初始化交通出行的总数据
   * @param acc：账号
   */
  public async setOriginalTotalData(acc: string) {
    if (!this.foodStore) {
      CarEmiFoodLogger.error('数据库创建失败')
      return
    }
    const valueBucket: relationalStore.ValuesBucket = {
      ACCOUNT: acc,
      TOTAL_EMISSION: 0.0,
      TOTAL_DAY: 0,
      MONTHLY_EMISSION: 0.0,
      MONTHLY_ORDER: 0,
      MONTHLY_PORTION: 0.0,
      POINT: 0,
      MEDAL: 0,
      TIME_TOKEN: '1/1/1999'
    }
    try {
      const rowId = await this.foodStore.insert(this.foodTotalName, valueBucket)
      CarEmiFoodLogger.info(acc + 'Total初始化数据成功：' + `rowId:${rowId}`)
    } catch (error) {
      CarEmiFoodLogger.error(acc + 'Total初始化数据失败：' + error)
    }
  }

  /**
   * 用户登录时返回总数据，供给 UI 渲染页面
   * @param acc：账号
   * @returns ：返回总数据对象
   */
  public async getFoodTotalData(acc: string): Promise<FoodTotalDataType> {
    let resultItem: FoodTotalDataType = {
      id: -1,
      account: '',
      total_emission: 0,
      total_day: 0,
      monthly_emission: 0,
      monthly_order: 0,
      monthly_portion: 0,
      point: 0,
      medal: 0,
      time_token: ''
    }

    return new Promise((resolve) => {
      if (!this.foodStore) {
        CarEmiFoodLogger.error('数据库创建失败')
        resolve(resultItem)
        return
      }
      const predicates2 = new relationalStore.RdbPredicates(this.foodTotalName)
      predicates2.equalTo('ACCOUNT', acc)

      this.foodStore.query(predicates2,
        ['USER_ID', 'ACCOUNT', 'TOTAL_EMISSION', 'TOTAL_DAY', 'MONTHLY_EMISSION',
          'MONTHLY_ORDER', 'MONTHLY_PORTION', 'POINT', 'MEDAL', 'TIME_TOKEN'],
        (err: BusinessError, resultSet) => {
          if (err) {
            CarEmiFoodLogger.error('查询失败1：' + `code is ${err.code},message is ${err.message}`)
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
              const monthly_portion = resultSet.getDouble(resultSet.getColumnIndex('MONTHLY_PORTION'))
              const point = resultSet.getLong(resultSet.getColumnIndex('POINT'))
              const medal = resultSet.getLong(resultSet.getColumnIndex('MEDAL'))
              const account = resultSet.getString(resultSet.getColumnIndex('ACCOUNT'))
              const time_token = resultSet.getString(resultSet.getColumnIndex('TIME_TOKEN'))
              if (account === acc) {
                resultItem.id = id
                resultItem.total_emission = total_emission
                resultItem.total_day = total_day
                resultItem.monthly_emission = monthly_emission
                resultItem.monthly_order = monthly_order
                resultItem.monthly_portion = monthly_portion
                resultItem.point = point
                resultItem.medal = medal
                resultItem.account = account
                resultItem.time_token = time_token
                CarEmiFoodLogger.info('找到指定账户：' +
                  `id=${id}, account=${account}, total_emission=${total_emission},
                  total_day=${total_day}, monthly_emission=${monthly_emission}, monthly_order=${monthly_order},
                  monthly_portion=${monthly_portion}, point=${point}, medal=${medal},
                  time_token=${time_token}`)
                isExist = true
                break
              }
            }
          } catch (error) {
            CarEmiFoodLogger.error('查询失败2：' + error)
            isExist = false
          } finally {
            resultSet.close()
          }
          if (isExist) {
            resolve(resultItem)
          } else {
            CarEmiFoodLogger.info('未找到该用户，可以创建为新用户')
            resolve(resultItem)
          }
        })
    })
  }

  /**
   * 更新总数据
   * @param acc：账号
   */
  public async updateTotalData(data: FoodTotalDataType) {
    if (!this.foodStore) {
      CarEmiFoodLogger.error('数据库创建失败')
      return
    }
    const valueBucket2: relationalStore.ValuesBucket = {
      ACCOUNT: data.account,
      TOTAL_EMISSION: data.total_emission,
      TIME_TOKEN: data.time_token,
      TOTAL_DAY: data.total_day,
      MONTHLY_EMISSION: data.monthly_emission,
      MONTHLY_ORDER: data.monthly_order,
      MONTHLY_PORTION: data.monthly_portion,
      POINT: data.point,
      MEDAL: data.medal,
    }

    let predicates1 = new relationalStore.RdbPredicates(this.foodTotalName)
    predicates1.equalTo('ACCOUNT', data.account)

    this.foodStore.update(valueBucket2, predicates1,
      (err: BusinessError, rows: number) => {
        if (err) {
          CarEmiFoodLogger.error('Total更新失败: ' + `code is ${err.code},message is ${err.message}`)
        }
        CarEmiFoodLogger.info('Total更新成功: ' + `rows:${rows};` +
          `id=${data.id}, account=${data.account}, total_emission=${data.total_emission},
         total_day=${data.total_day}, monthly_emission=${data.monthly_emission}, monthly_order=${data.monthly_order},
         monthly_portion=${data.monthly_portion}, point=${data.point}, medal=${data.medal},
         time_token=${data.time_token}`)
      })
  }
}