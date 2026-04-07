import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"

@Component
export struct BackButtonOri {
  @Prop pageTitle: ResourceStr | string = ''

  build() {
    Row({ space: 10 }) {
      Row({ space: 8 }) {
        Image($r('app.media.arrow_up'))
          .width(38)
          .rotate({ angle: -90 })
          .backgroundColor('#fff3f3f3')
          .fillColor('#37800f')
          .padding(10)
          .borderRadius(25)
          .onClick(() => {
            if (this.pageTitle === '帖子详情') {
              RouterModule.pop(RouterNameConstants.ENTRY_HAP)
            } else {
              RouterModule.pop(BuilderNameConstants.HAR_carboncircle_comment)
            }
          })

        Text(this.pageTitle)
          .fontSize(26)
          .fontColor('#000000')
          .fontWeight(700)
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ top: 35, left: 20, right: 20 })
    .margin({ bottom: 5 })
  }
}