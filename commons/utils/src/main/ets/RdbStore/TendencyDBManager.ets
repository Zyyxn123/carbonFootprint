import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { TendencyRdbLogger, TendMapFootLogger } from '../Hilog/HilogInfo';

export class TendencyDBManager {
  private static instance: TendencyDBManager
  private readonly myStoreName: string = 'TendencyRdbStore'
  private readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: this.myStoreName,
    securityLevel: relationalStore.SecurityLevel.S2
  }
  public tendencyRdbStore: relationalStore.RdbStore | undefined = undefined

  public static getInstance(): TendencyDBManager {
    if (!TendencyDBManager.instance) {
      TendencyDBManager.instance = new TendencyDBManager()
    }
    TendencyRdbLogger.info('DBManager创建成功')
    return TendencyDBManager.instance
  }

  public async initDB(context: Context) {
    relationalStore.getRdbStore(context, this.STORE_CONFIG,
      (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
        if (err) {
          TendencyRdbLogger.error('数据库创建失败')
          return
        }
        this.tendencyRdbStore = rdbStore
        TendencyRdbLogger.info('数据库创建成功')

        TendMapFootLogger.info('数据库创建成功')
      })
  }

  public getRdbStore(): relationalStore.RdbStore | undefined {
    return this.tendencyRdbStore
  }
}