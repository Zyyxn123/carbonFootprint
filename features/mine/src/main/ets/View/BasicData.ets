import { UserRdbStore } from "@ohos/utils"
import { UserDataViewModel } from "../ViewModel/UserDataViewModel"

@Component
export struct basicData {
  private userDataVM: UserDataViewModel = new UserDataViewModel()

  async aboutToAppear(): Promise<void> {
    await this.userDataVM.getUserData()
  }

  build() {
    Row() {
      Column({ space: 15 }) {
        Image($r(`app.media.${this.userDataVM.avatar}`))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ left: 25, right: 15 })

        Row() {
          Text(this.userDataVM.name)
            .fontSize(20)
            .fontWeight(600)
            .fontColor(Color.Black)
        }
        .margin({ left: 25, right: 15 })
      }
      .justifyContent(FlexAlign.Center)


      Column({ space: 10 }) {
        Text('关注 124     粉丝 99')
          .fontSize(15)
          .fontColor(Color.Black)
        Text('贡献 30     积分 1331')
          .fontSize(15)
          .fontColor(Color.Black)
      }
      .alignItems(HorizontalAlign.Start)
      .backgroundColor(Color.White)
      .border({ width: 1, color: '#ffeaeaea', radius: 15 })
      .padding(15)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .height(220)
    .width('100%')
  }
}