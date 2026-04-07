import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"

@Component
export struct additionalInfo {
  build() {
    Row() {
      Text('你的专属 AI 小助手')
        .fontSize(18)
        .textAlign(TextAlign.Start)
        .fontColor($r('app.color.recAndTask_title_color'))
        .margin({ left: 15, top: 10, bottom: 6 })
        .fontWeight(600)
      Image($r('app.media.arrow_up'))
        .width(24)
        .fillColor('#000')
        .rotate({
          angle: 90
        })
    }
    .height(40)
    .border({ width: { bottom: 1, right: 1 }, color: '#37800f'})
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [['#ff4b9d1f', 0.2], ['#edffdd', 0.6], ['#fff', 0.7]]
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(10)
    .width('100%')
    .onClick(async () => {
      buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_tendency_aiAssistant)
    })
  }
}