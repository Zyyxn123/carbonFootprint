import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { CarbonMsgRdbLogger } from '../Hilog/HilogInfo';

export class CarbonMsgDBManager {
  private static instance: CarbonMsgDBManager
  private readonly myStoreName: string = 'CarbonMsgRdbStore'
  private readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: this.myStoreName,
    securityLevel: relationalStore.SecurityLevel.S2
  }
  public carbonMsgRdbStore: relationalStore.RdbStore | undefined = undefined

  public static getInstance(): CarbonMsgDBManager {
    if (!CarbonMsgDBManager.instance) {
      CarbonMsgDBManager.instance = new CarbonMsgDBManager()
    }
    CarbonMsgRdbLogger.info('DBManager创建成功')
    return CarbonMsgDBManager.instance
  }

  public async initDB(context: Context) {
    relationalStore.getRdbStore(context, this.STORE_CONFIG,
      (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
        if (err) {
          CarbonMsgRdbLogger.error('数据库创建失败')
          return
        }
        this.carbonMsgRdbStore = rdbStore
        CarbonMsgRdbLogger.info('数据库创建成功')
      })
  }

  public getRdbStore(): relationalStore.RdbStore | undefined {
    return this.carbonMsgRdbStore
  }
}