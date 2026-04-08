import { BuilderNameConstants, buildRouterModel, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import mapFootVM from "../ViewModel/MapFootprintViewModel"

@Component
export struct backButton {
  @Prop pageTitle: ResourceStr | string = ''
  @Link bol: boolean

  build() {
    Row({ space: 10 }) {
      Image($r('app.media.arrow_up'))
        .width(38)
        .rotate({ angle: -90 })
        .backgroundColor('#ccc')
        .fillColor('#37800f')
        .padding(10)
        .borderRadius(25)
        .onClick(() => {
          if (this.pageTitle === '碳足迹') {
            mapFootVM.getLatelyData()
          }
          AppStorage.set('expandSafeArea', false)
          this.bol = false
          RouterModule.pop(RouterNameConstants.ENTRY_HAP)
        })

      Text(this.pageTitle)
        .fontSize(26)
        .fontColor('#000000')
        .fontWeight(700)
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .padding({ top: 35, left: 20, bottom: 10})
    .margin({ bottom: 5 })
    .backgroundBlurStyle(BlurStyle.Thin,
      { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 1.0 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.END])
  }
}