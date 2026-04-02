import { BuilderNameConstants, buildRouterModel, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { AccJWTPreference, HTTPForCarCircle } from "@ohos/utils"
import msgListVM from "../ViewModel/MsgListViewModel"
import userDataVM from "../ViewModel/UserDataViewModel"

@Component
export struct backButton {
  @Prop pageTitle: ResourceStr | string = ''
  @Link hasContent: boolean
  @Link imgSrc: string[]
  @Link textStr: string
  private httpForCarCircleIns: HTTPForCarCircle = HTTPForCarCircle.getInstance()
  private accJWTPre: AccJWTPreference = AccJWTPreference.getInstance()
  build() {
    Row({ space: 10 }) {
      Row({ space: 8 }) {
        Image($r('app.media.arrow_up'))
          .width(38)
          .rotate({ angle: -90 })
          .backgroundColor('#fff3f3f3')// fff5f5f5
          .fillColor('#37800f')
          .padding(10)
          .borderRadius(25)
          .onClick(() => {
            RouterModule.pop(RouterNameConstants.ENTRY_HAP)
          })

        Text(this.pageTitle)
          .fontSize(26)
          .fontColor('#000000')
          .fontWeight(700)
      }

      Row() {
        Text('发表')
          .fontColor(this.hasContent ? '#fff' : '#ccc')
          .fontSize(15)
          .onClick(() => {
            if (this.hasContent) {
              const acc = AppStorage.get('currLoginAcc') as string
              const title: string = '今日分享'
              const name: string =  userDataVM.name
              const avatar: string =  userDataVM.avatar
              const date = new Date().toLocaleString()
              const JWT = this.accJWTPre.getCurrAccJWT(acc)
              this.httpForCarCircleIns.setJWT(JWT)
              console.log('send msg: ' + `acc=${acc}, name=${name}, avatar=${avatar}, date=${date}`)
              // msgListVM.setMsg(acc, name, avatar, this.imgSrc, this.textStr, date, 0)
              this.httpForCarCircleIns.httpForPublishData(title, this.textStr,  this.imgSrc, avatar)

              this.getUIContext().getPromptAction().showToast({
                message: '发表成功',
                bottom: 80,
                duration: 2000
              })
              this.hasContent = false
              RouterModule.pop(RouterNameConstants.ENTRY_HAP)
            }
          })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width(50)
      .height(35)
      .backgroundColor(this.hasContent ? '#07C160' : '#ffececec')
      .borderRadius(6)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ top: 35, left: 20, right: 20 })
    .margin({ bottom: 5 })
  }
}