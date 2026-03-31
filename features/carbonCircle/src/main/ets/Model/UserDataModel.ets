import { UserBasicDataType, UserRdbStore } from "@ohos/utils";

export class UserDataModel {
  static userRdbStoreIns: UserRdbStore = UserRdbStore.getInstance()

  public static async getBasicData() {
   const dataItem: UserBasicDataType = await UserDataModel.userRdbStoreIns.getCurrAccData()
    return dataItem
  }
}