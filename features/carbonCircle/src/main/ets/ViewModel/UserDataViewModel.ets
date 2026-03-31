import { UserBasicDataType } from "@ohos/utils"
import { UserDataModel } from "../Model/UserDataModel"

@ObservedV2
class UserDataViewModel {
  @Trace name: string = ''
  @Trace avatar: string = ''
  @Trace signature: string = ''


  public async getUserData() {
    const dataItem: UserBasicDataType = await UserDataModel.getBasicData()
    this.name = dataItem.name
    this.avatar = dataItem.avatar
    this.signature = dataItem.signature
  }
}

const userDataVM: UserDataViewModel = new UserDataViewModel()

export default userDataVM