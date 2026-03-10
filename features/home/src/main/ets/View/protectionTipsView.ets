import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"

@Component
export struct protectionTipsView {
  build() {
    Column({ space: 10 }) {
      Text($r('app.string.protectionTips_title'))
        .fontColor($r('app.color.protectionTipsView_title_background'))
        .fontSize(18)
        .fontWeight(600)

      Row({ space: 10 }) {
        Row({ space: 30 }) {
          Image($r('app.media.protectionTips_one'))
            .width(40)
            .margin({ left: 15 })

          Column({ space: 15 }) {
            Text($r('app.string.protectionTipsView_title'))
              .fontColor($r('app.color.protectionTipsView_title_background'))
              .fontWeight(600)
              .fontSize(18)

            Text($r('app.string.protectionTipsView_content'))
              .fontColor($r('app.color.protectionTipsView_content_background'))
              .fontWeight(400)
              .fontSize(12)
          }
          .width('60%')
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(VerticalAlign.Center)
        .width('78%')
        .height(100)
        .backgroundColor($r('app.color.protectionTipsView_total_background'))
        .border({ width: 1, color: $r('app.color.protectionTipsView_border')})
        .borderRadius(25)
        .onClick(() => {
          buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_home_environmentalTip);
        })

        Row() {
          Image($r('app.media.protectionTips_two'))
            .width(30)
        }
        .backgroundColor($r('app.color.protectionTipsView_button_background'))
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('18%')
        .borderRadius(15)
        .height(100)
      }
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .height(130)
    .width('100%')
    .padding({ left: 10, right: 10 })
  }
}