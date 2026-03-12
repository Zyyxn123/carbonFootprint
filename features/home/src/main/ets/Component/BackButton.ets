import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"

@Component
export struct backButton {
  @Prop pageTitle: ResourceStr | string = ''

  build() {
    Row({ space: 10 }) {
      Image($r('app.media.arrow_up'))
        .width(38)
        .rotate({ angle: -90 })
        .backgroundColor('#fff3f3f3')// fff5f5f5
        .fillColor('#37800f')
        .padding(10)
        .borderRadius(25)
        .onClick(() => {
          (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
        })

      Text(this.pageTitle)
        .fontSize(26)
        .fontColor('#000000')
        .fontWeight(700)
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .padding({ left: 20 })
    .margin({ bottom: 5 })
  }
}