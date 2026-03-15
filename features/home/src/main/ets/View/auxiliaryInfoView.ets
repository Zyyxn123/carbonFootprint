import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"

@Component
export struct auxiliaryInfoView {
  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.verticalBar'))
          .width(30)
          .fillColor($r('app.color.auxiliaryInfoView_verticalBar'))

        Text($r('app.string.auxiliaryInfoView_title'))
          .fontColor($r('app.color.auxiliaryInfoView_title_background'))
          .fontSize(18)
          .fontWeight(600)
      }

      Row({ space: 10 }) {
        Image($r('app.media.levelDecode'))
          .width(20)
          .fillColor($r('app.color.auxiliaryInfoView_img'))
          .margin({ left: 11, right: 5 })

        Column({ space: 10 }) {
          Text($r('app.string.auxiliaryInfoView_title_two'))
            .fontColor($r('app.color.auxiliaryInfoView_title'))
            .fontWeight(600)
            .fontSize(16)

          Text($r('app.string.auxiliaryInfoView_content_two'))
            .fontColor($r('app.color.auxiliaryInfoView_content'))
            .fontWeight(500)
            .fontSize(12)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Image($r('app.media.onwards'))
          .width(20)
          .fillColor($r('app.color.auxiliaryInfoView_onwards'))
          .margin({ right: 10 })
          .onClick(() => {
            buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_home_reduceCarbonEmissionMethod)
          })
      }
      .height(65)
      .width('100%')
      .borderRadius(25)
      .border({ width: { left: 2, bottom: 1 }, color: $r('app.color.auxiliaryInfoView_border') })
      .justifyContent(FlexAlign.SpaceBetween)

      // ToDo: 只用记录碳排放的因子，计算公式一些简单数据
      Row({ space: 10 }) {
        Image($r('app.media.detailedAttention'))
          .width(30)
          .fillColor($r('app.color.auxiliaryInfoView_img'))
          .margin({ left: 5 })

        Column({ space: 10 }) {
          Text($r('app.string.auxiliaryInfoView_title_one'))
            .fontColor($r('app.color.auxiliaryInfoView_title'))
            .fontWeight(600)
            .fontSize(16)

          Text($r('app.string.auxiliaryInfoView_content_one'))
            .fontColor($r('app.color.auxiliaryInfoView_content'))
            .fontWeight(500)
            .fontSize(12)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Image($r('app.media.onwards'))
          .width(20)
          .fillColor($r('app.color.auxiliaryInfoView_onwards'))
          .margin({ right: 10 })
          .onClick(() => {
            buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_home_detailCarbonEmission)
          })
      }
      .height(65)
      .width('100%')
      .borderRadius(25)
      .border({ width: { left: 2, bottom: 1 }, color: $r('app.color.auxiliaryInfoView_border') })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .padding({ left: 10, right: 10 })
    .margin({ top: 8 })
  }
}