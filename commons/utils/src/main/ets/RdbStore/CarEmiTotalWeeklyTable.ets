import { CarbonMsgDBManager } from './CarbonMsgDBManager'
import { relationalStore } from '@kit.ArkData'
import { CarEmiTotalWeeklyLogger } from '../Hilog/HilogInfo'
import { CarbonMsgSQLConstants } from '../Constants/CarbonMsgSQL'
import { WeeklyTotalDataType } from '../Interface/WeeklyTotalDataType'


export class CarEmiTotalWeeklyTable {
  private static instance: CarEmiTotalWeeklyTable
  private readonly totalWeeklyTableName: string = 'totalWeeklyDataTable'
  public totalWeeklyStore: relationalStore.RdbStore | undefined = undefined
  private DBManager: CarbonMsgDBManager = CarbonMsgDBManager.getInstance()

  public static getInstance(): CarEmiTotalWeeklyTable {
    if (!CarEmiTotalWeeklyTable.instance) {
      CarEmiTotalWeeklyTable.instance = new CarEmiTotalWeeklyTable()
    }
    return CarEmiTotalWeeklyTable.instance
  }

  public async initTable() {
    if (this.DBManager.carbonMsgRdbStore === undefined) {
      CarEmiTotalWeeklyLogger.error('数据库创建失败')
      return
    }
    this.totalWeeklyStore = this.DBManager.carbonMsgRdbStore

    try {
      await this.totalWeeklyStore.execute(CarbonMsgSQLConstants.createTotalWeeklySQL(this.totalWeeklyTableName))
      CarEmiTotalWeeklyLogger.info('表创建成功')
    } catch (error) {
      CarEmiTotalWeeklyLogger.error('表创建失败：' + error)
    }
  }

  public async deleteMyTable() {
    if (!this.totalWeeklyStore) {
      CarEmiTotalWeeklyLogger.error('数据库创建失败')
      return
    }
    try {
      await this.totalWeeklyStore.execute(CarbonMsgSQLConstants.deleteTableSQL(this.totalWeeklyTableName))
      CarEmiTotalWeeklyLogger.info('表删除成功')
    } catch (error) {
      CarEmiTotalWeeklyLogger.error('表删除失败：' + error)
    }
  }

  /**
   * 新建用户时初始化总数据 || 新的一天时初始化总数据
   * @param acc：账号
   */
  public async setOriginalTotalData(acc: string, date: string) {
    if (!this.totalWeeklyStore) {
      CarEmiTotalWeeklyLogger.error('数据库创建失败')
      return
    }
    const valueBucket: relationalStore.ValuesBucket = {
      account: acc,
      record_date: date,
      travel_carbon: 0.0,
      electric_carbon: 0.0,
      food_carbon: 0.0,
      total_carbon: 0.0,
      current_week_daily_carbon: '[0,0,0,0,0,0,0]',
      last_week_daily_carbon: '[0,0,0,0,0,0,0]',
    }
    try {
      const rowId = await this.totalWeeklyStore.insert(this.totalWeeklyTableName, valueBucket)
      CarEmiTotalWeeklyLogger.info(acc + '初始化数据成功：' + `rowId:${rowId}`)
    } catch (error) {
      CarEmiTotalWeeklyLogger.error(acc + '初始化数据失败：' + error)
    }
  }

  /**
   *用户登录时返回总数据，供给 UI 渲染页面
   * @param acc：账号
   * @param date：日期
   * @returns：返回总数据对象
   */
  public async getWeeklyTotalData(acc: string, date: string): Promise<WeeklyTotalDataType> {
    let resultItem: WeeklyTotalDataType = {
      id: -1,
      account: '',
      record_date: '',
      travel_carbon: 0,
      electric_carbon: 0,
      food_carbon: 0,
      total_carbon: 0,
      current_week_daily_carbon: '[0,0,0,0,0,0,0]',
      last_week_daily_carbon: '[0,0,0,0,0,0,0]'
    }

    return new Promise((resolve) => {
      if (!this.totalWeeklyStore) {
        CarEmiTotalWeeklyLogger.error('数据库创建失败')
        resolve(resultItem)
        return
      }
      const predicates2 = new relationalStore.RdbPredicates(this.totalWeeklyTableName)
      predicates2.equalTo('ACCOUNT', acc)

      this.totalWeeklyStore.query(predicates2,
        ['id', 'account', 'record_date', 'travel_carbon', 'electric_carbon',
          'food_carbon', 'total_carbon', 'current_week_daily_carbon', 'last_week_daily_carbon'],
        (err: BusinessError, resultSet) => {
          if (err) {
            CarEmiTotalWeeklyLogger.error('查询失败1：' + `code is ${err.code},message is ${err.message}`)
            resultSet?.close()
            resolve(resultItem)
            return
          }

          let isExist = false

          try {
            while (resultSet.goToNextRow()) {
              const id = resultSet.getLong(resultSet.getColumnIndex('id'))
              const account = resultSet.getString(resultSet.getColumnIndex('account'))
              const record_date = resultSet.getString(resultSet.getColumnIndex('record_date'))
              const travel_carbon = resultSet.getDouble(resultSet.getColumnIndex('travel_carbon'))
              const electric_carbon = resultSet.getDouble(resultSet.getColumnIndex('electric_carbon'))
              const food_carbon = resultSet.getDouble(resultSet.getColumnIndex('food_carbon'))
              const total_carbon = resultSet.getDouble(resultSet.getColumnIndex('total_carbon'))
              const current_week_daily_carbon =
                resultSet.getString(resultSet.getColumnIndex('current_week_daily_carbon'))
              const last_week_daily_carbon = resultSet.getString(resultSet.getColumnIndex('last_week_daily_carbon'))
              if (account === acc && record_date === date) {
                resultItem.id = id
                resultItem.record_date = record_date
                resultItem.food_carbon = food_carbon
                resultItem.travel_carbon = travel_carbon
                resultItem.electric_carbon = electric_carbon
                resultItem.total_carbon = total_carbon
                resultItem.current_week_daily_carbon = current_week_daily_carbon
                resultItem.last_week_daily_carbon = last_week_daily_carbon
                resultItem.account = account
                CarEmiTotalWeeklyLogger.info('找到指定账户：' +
                  `id=${id}, account=${account}, record_date=${record_date},
                  food_carbon=${food_carbon}, travel_carbon=${travel_carbon}, electric_carbon=${electric_carbon},
                  total_carbon=${total_carbon}, current_week_daily_carbon=${current_week_daily_carbon},
                  last_week_daily_carbon=${last_week_daily_carbon}`)
                isExist = true
                break
              }
            }
          } catch (error) {
            CarEmiTotalWeeklyLogger.error('查询失败2：' + error)
            isExist = false
          } finally {
            resultSet.close()
          }
          if (isExist) {
            resolve(resultItem)
          } else {
            CarEmiTotalWeeklyLogger.info('未找到该用户，可以创建为新用户')
            resolve(resultItem)
          }
        })
    })
  }

  /**
   * 更新总数据
   * @param data：账号信息
   * @param date：日期
   */
  public async updateTotalData(data: WeeklyTotalDataType, date: string) {
    if (!this.totalWeeklyStore) {
      CarEmiTotalWeeklyLogger.error('数据库创建失败')
      return
    }
    const valueBucket2: relationalStore.ValuesBucket = {
      account: data.account,
      record_date: data.record_date,
      travel_carbon: data.travel_carbon,
      electric_carbon: data.electric_carbon,
      food_carbon: data.food_carbon,
      total_carbon: data.total_carbon,
      current_week_daily_carbon: data.current_week_daily_carbon,
      last_week_daily_carbon: data.last_week_daily_carbon
    }

    let predicates1 = new relationalStore.RdbPredicates(this.totalWeeklyTableName)
    predicates1.equalTo('account', data.account)
      .and()
      .equalTo('record_date', date)

    this.totalWeeklyStore.update(valueBucket2, predicates1,
      (err: BusinessError, rows: number) => {
        if (err) {
          CarEmiTotalWeeklyLogger.error('更新失败: ' + `code is ${err.code},message is ${err.message}`)
        }
        CarEmiTotalWeeklyLogger.info('更新成功: ' + `rows:${rows};` +
          `id=${data.id}, account=${data.account}, record_date=${data.record_date},
         travel_carbon=${data.travel_carbon}, electric_carbon=${data.electric_carbon}, food_carbon=${data.food_carbon},
         total_carbon=${data.total_carbon}, current_week_daily_carbon=${data.current_week_daily_carbon},
         last_week_daily_carbon=${data.last_week_daily_carbon}`)
      })
  }

  public async hasTodayItem(acc: string, date: string): Promise<boolean> {
    return new Promise((resolve) => {
      if (!this.totalWeeklyStore) {
        CarEmiTotalWeeklyLogger.error('数据库创建失败')
        resolve(false)
        return
      }
      const predicates2 = new relationalStore.RdbPredicates(this.totalWeeklyTableName)
      predicates2.equalTo('ACCOUNT', acc)

      this.totalWeeklyStore.query(predicates2,
        ['id', 'account', 'record_date', 'travel_carbon', 'electric_carbon',
          'food_carbon', 'total_carbon', 'current_week_daily_carbon',
          'last_week_daily_carbon',],
        (err: BusinessError, resultSet) => {
          if (err) {
            CarEmiTotalWeeklyLogger.error('查询失败1：' + `code is ${err.code},message is ${err.message}`)
            resultSet?.close()
            resolve(false)
            return
          }

          let isExist = false
          try {
            while (resultSet.goToNextRow()) {
              const id = resultSet.getLong(resultSet.getColumnIndex('id'))
              const account = resultSet.getString(resultSet.getColumnIndex('account'))
              const record_date = resultSet.getString(resultSet.getColumnIndex('record_date'))
              const travel_carbon = resultSet.getString(resultSet.getColumnIndex('travel_carbon'))
              const electric_carbon = resultSet.getString(resultSet.getColumnIndex('electric_carbon'))
              const food_carbon = resultSet.getString(resultSet.getColumnIndex('food_carbon'))
              const total_carbon = resultSet.getString(resultSet.getColumnIndex('total_carbon'))
              const current_week_daily_carbon =
                resultSet.getString(resultSet.getColumnIndex('current_week_daily_carbon'))
              const last_week_daily_carbon = resultSet.getString(resultSet.getColumnIndex('last_week_daily_carbon'))
              if (account === acc && record_date === date) {
                CarEmiTotalWeeklyLogger.info('找到指定账户：' +
                  `id=${id}, account=${account}, record_date=${record_date}, travel_carbon=${travel_carbon},
                   electric_carbon=${electric_carbon}, food_carbon=${food_carbon}, total_carbon=${total_carbon},
                   current_week_daily_carbon=${current_week_daily_carbon}, last_week_daily_carbon=${last_week_daily_carbon}`)
                isExist = true
                break
              }
            }
          } catch (error) {
            CarEmiTotalWeeklyLogger.error('查询失败2：' + error)
            isExist = false
          } finally {
            resultSet.close()
          }
          if (isExist) {
            resolve(true)
          } else {
            CarEmiTotalWeeklyLogger.info('未找到该用户，可以创建为新用户')
            resolve(false)
          }
        }
      )
    })
  }
}