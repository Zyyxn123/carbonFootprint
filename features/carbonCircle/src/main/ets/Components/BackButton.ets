import { BuilderNameConstants, buildRouterModel, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { AccJWTPreference, HTTPForCarCircle } from "@ohos/utils"
import msgListVM from "../ViewModel/MsgListViewModel"
import userDataVM from "../ViewModel/UserDataViewModel"

@Component
export struct backButton {
  @Prop pageTitle: ResourceStr | string = ''
  @Link hasContent: boolean
  @Link isLoading: boolean
  @Link imgSrc: string[]
  @Link textStr: string
  @Link titleStr: string
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
          .fontColor(this.hasContent && this.textStr ? '#fff' : '#ccc')
          .fontSize(15)
          .onClick(() => {
            if (this.textStr === '') {
              this.getUIContext().getPromptAction().showToast({
                message: '内容不能为空',
                bottom: 80,
                duration: 2000
              })
            } else {
              if (this.hasContent) {
                const acc = AppStorage.get('currLoginAcc') as string
                const title: string = this.titleStr
                const text: string = this.textStr
                const name: string = userDataVM.name
                const avatar: string = userDataVM.avatar
                const JWT = this.accJWTPre.getCurrAccJWT(acc)
                this.httpForCarCircleIns.setJWT(JWT)
                console.log('send msg: ' + `acc=${acc}, name=${name},
                 avatar=${avatar}, JWT=${JWT}`)
                msgListVM.sendPostToServer(title, text, this.imgSrc, avatar)
                this.isLoading = true

                setTimeout(() => {
                  if (this.httpForCarCircleIns.returnData !== undefined &&
                    this.httpForCarCircleIns.returnData.id !== undefined) {
                    this.getUIContext().getPromptAction().showToast({
                      message: '发表成功',
                      bottom: 80,
                      duration: 1500
                    })
                  } else {
                    this.getUIContext().getPromptAction().showToast({
                      message: '发表失败',
                      bottom: 80,
                      duration: 1500
                    })
                  }
                  RouterModule.pop(RouterNameConstants.ENTRY_HAP)
                  this.hasContent = false
                  this.isLoading = false
                }, 4000)
              } else {
                this.getUIContext().getPromptAction().showToast({
                  message: '内容出错，请重新尝试',
                  bottom: 80,
                  duration: 1500
                })
              }
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