import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { UserSQLConstants } from '../Constants/UserSQL';
import { UserRdbLogger } from '../Hilog/HilogInfo';
import { UserBasicDataType } from '../Interface/UserBasicDataType';

export class UserRdbStore {
  private static instance: UserRdbStore
  private readonly myStoreName: string = 'UserRdbStore'
  private readonly myTableName: string = 'UserBasicDataTable'
  private readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: this.myStoreName,
    securityLevel: relationalStore.SecurityLevel.S2
  }
  public userRdbStore: relationalStore.RdbStore | undefined = undefined
  public currAcc: string = ''

  public static getInstance(): UserRdbStore {
    if (!UserRdbStore.instance) {
      UserRdbStore.instance = new UserRdbStore()
    }
    return UserRdbStore.instance
  }

  public initMyStore(context: Context) {
    relationalStore.getRdbStore(context, this.STORE_CONFIG,
      async (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
        if (err) {
          UserRdbLogger.error('数据库创建失败')
          return
        }
        this.userRdbStore = rdbStore
        UserRdbLogger.info('数据库创建成功')

        try {
          await this.userRdbStore.execute(UserSQLConstants.createUserStoreSQL(this.myTableName))
          UserRdbLogger.info('表创建成功')
        } catch (error) {
          UserRdbLogger.error('表创建失败：' + error)
        }
      })
  }

  public async deleteMyTable() {
    if (!this.userRdbStore) {
      UserRdbLogger.error('数据库创建失败')
      return
    }
    try {
      await this.userRdbStore.execute(UserSQLConstants.deleteUserTableSQL(this.myTableName))
      UserRdbLogger.info('表删除成功')
    } catch (error) {
      UserRdbLogger.error('表删除失败：' + error)
    }
  }

  public async setOriginalData(acc: string) {
    if (!this.userRdbStore) {
      UserRdbLogger.error('数据库创建失败')
      return
    }
    const valueBucket: relationalStore.ValuesBucket = {
      ACCOUNT: acc,
      USERNAME: '华为用户',
      AVATAR: 'avatar_1th',
      SIGNATURE: '该用户还未设置签名'
    }

    try {
      const rowId = await this.userRdbStore.insert(this.myTableName, valueBucket)
      UserRdbLogger.info(acc + '初始化数据成功：' + `rowId:${rowId}`)
    } catch (error) {
      UserRdbLogger.error(acc + '初始化数据失败：' + error)
    }
  }

  public async hasAcc(acc: string): Promise<boolean> {
    return new Promise((resolve) => {
      this.currAcc = acc
      if (!this.userRdbStore) {
        UserRdbLogger.error('数据库创建失败')
        resolve(false)
        return
      }
      const predicates2 = new relationalStore.RdbPredicates(this.myTableName)
      predicates2.equalTo('ACCOUNT', acc)

      this.userRdbStore.query(predicates2,
        ['USER_ID', 'USERNAME', 'ACCOUNT', 'AVATAR', 'SIGNATURE'], (err: BusinessError, resultSet) => {
          if (err) {
            UserRdbLogger.error('查询失败1：' + `code is ${err.code},message is ${err.message}`)
            resultSet?.close()
            resolve(false)
            return
          }

          let isExist = false; // 存储查询结果
          try {
            while (resultSet.goToNextRow()) {
              const id = resultSet.getLong(resultSet.getColumnIndex('USER_ID'))
              const name = resultSet.getString(resultSet.getColumnIndex('USERNAME'))
              const account = resultSet.getString(resultSet.getColumnIndex('ACCOUNT'))
              const avatar = resultSet.getString(resultSet.getColumnIndex('AVATAR'))
              const signature = resultSet.getString(resultSet.getColumnIndex('SIGNATURE'))
              if (account === acc) {
                UserRdbLogger.info('找到指定账户：' +
                  `id=${id}, name=${name}, account=${account}, avatar=${avatar}, signature=${signature}`)
                isExist = true
                break
              }
            }
          } catch (error) {
            UserRdbLogger.error('查询失败2：' + error)
            isExist = false
          } finally {
            resultSet.close()
          }
          if (isExist) {
            resolve(true)
          } else {
            UserRdbLogger.info('未找到该用户，可以创建为新用户')
            resolve(false)
          }
        }
      )
    })
  }

  public async getCurrAccData(): Promise<UserBasicDataType> {
    let resultItem: UserBasicDataType = {
      id: -1,
      name: '华为用户',
      signature: '该用户还未设置签名',
      avatar: 'avatar_1th',
      account: this.currAcc
    }
    return new Promise((resolve) => {
      if (!this.userRdbStore) {
        UserRdbLogger.error('数据库创建失败')
        resolve(resultItem)
        return
      }
      const predicates2 = new relationalStore.RdbPredicates(this.myTableName)
      predicates2.equalTo('ACCOUNT', this.currAcc)

      this.userRdbStore.query(predicates2,
        ['USER_ID', 'USERNAME', 'ACCOUNT', 'AVATAR', 'SIGNATURE'], (err: BusinessError, resultSet) => {
          if (err) {
            UserRdbLogger.error('查询失败1：' + `code is ${err.code},message is ${err.message}`)
            resultSet?.close()
            resolve(resultItem)
            return
          }

          let isExist = false

          try {
            while (resultSet.goToNextRow()) {
              const id = resultSet.getLong(resultSet.getColumnIndex('USER_ID'))
              const name = resultSet.getString(resultSet.getColumnIndex('USERNAME'))
              const account = resultSet.getString(resultSet.getColumnIndex('ACCOUNT'))
              const avatar = resultSet.getString(resultSet.getColumnIndex('AVATAR'))
              const signature = resultSet.getString(resultSet.getColumnIndex('SIGNATURE'))
              if (account === this.currAcc) {
                resultItem.id = id
                resultItem.account = account
                resultItem.name = name
                resultItem.signature = signature
                resultItem.avatar = avatar
                UserRdbLogger.info('找到指定账户：' +
                  `id=${id}, name=${name}, account=${account}, avatar=${avatar}, signature=${signature}`)
                isExist = true
                break
              }
            }
          } catch (error) {
            UserRdbLogger.error('查询失败2：' + error)
            isExist = false
          } finally {
            resultSet.close()
          }

          if (isExist) {
            resolve(resultItem)
          } else {
            UserRdbLogger.info('未找到该用户，可以创建为新用户')
            resolve(resultItem)
          }
        }
      )
    })
  }
}