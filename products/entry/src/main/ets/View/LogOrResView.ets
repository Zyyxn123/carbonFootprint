import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"
import { HealthyNewsPreference, HTTPForHealthyNews } from "@ohos/utils"
import { common } from "@kit.AbilityKit"

@Component
export struct logOrResView {
  @State accountStr: string = ''
  @State passwordStr: string = ''
  private isSelected: boolean = false
  @StorageLink('entryHapRouter') entryHapRouter: NavPathStack = new NavPathStack()
  @State isLogin: boolean = false
  private healthyNewsPre: HealthyNewsPreference = HealthyNewsPreference.getInstance()
  private httpForHN: HTTPForHealthyNews = HTTPForHealthyNews.getInstance()
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext

  build() {
    Column() {
      Row() {
        Image($r('app.media.log_account'))
          .width(25)
          .fillColor($r('app.color.logOrRes_button_border'))

        TextInput({ placeholder: '请输入账号', text: $$this.accountStr })
          .backgroundColor(Color.Transparent)
          .width(260)
          .placeholderColor($r('app.color.logOrRes_button_word_a'))
          .fontColor($r('app.color.logOrRes_button_word_c'))
          .copyOption(CopyOptions.LocalDevice)
      }
      .width('85%')
      .height(50)
      .border({ radius: 25, color: $r('app.color.logOrRes_button_border'), width: 2 })
      .padding({ left: 12 })

      Row() {
        Image($r('app.media.log_password'))
          .width(25)
          .fillColor($r('app.color.logOrRes_button_border'))

        TextInput({ placeholder: '请输入密码', text: $$this.passwordStr })
          .width(275)
          .placeholderColor($r('app.color.logOrRes_button_word_a'))
          .fontColor($r('app.color.logOrRes_button_word_c'))
          .passwordIcon({ onIconSrc: $r('app.media.log_secret'), offIconSrc: $r('app.media.log_secret_selected') })
          .type(InputType.Password)
          .backgroundColor(Color.Transparent)
          .copyOption(CopyOptions.LocalDevice)

      }
      .width('85%')
      .height(50)
      .border({ radius: 25, color: $r('app.color.logOrRes_button_border'), width: 2 })
      .padding({ left: 12, right: 12 })
      .margin({ top: 25, bottom: 12 })

      Text($r('app.string.logOrRes_forgetPsw'))
        .fontColor($r('app.color.logOrRes_button_word_c'))
        .width('85%')
        .textAlign(TextAlign.End)
        .fontWeight(FontWeight.Medium)
        .fontSize(15)

      Button($r('app.string.logOrRes_button'))
        .fontSize(17)
        .fontColor($r('app.color.logOrRes_button_word'))
        .backgroundColor($r('app.color.logOrRes_button_background'))
        .width('85%')
        .height(50)
        .margin({ top: 30 })
        .borderRadius(25)
        .onClick(() => {
          this.isLogin = true

          setTimeout(() => {
            this.healthyNewsPre.setTodayData_HN(this.httpForHN.data) // 三种肿瘤早筛全攻略，请收好！
          }, 500)

          setTimeout(() => {
            this.entryHapRouter.pushPathByName('quickStart', null, false)
          }, 2000)
        })

      if (this.isLogin) {
        LoadingProgress()
          .color('37800f')
          .width(70)
          .margin({ top: 30 })
      }
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('72%')
    .backgroundColor($r('app.color.logOrRes_background_fore'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .borderRadius({ topLeft: 15, topRight: 15 })
    .shadow({ radius: 20, type: ShadowType.COLOR, color: $r('app.color.logOrRes_shadow') })
    .padding({ top: '10%' })
  }
}