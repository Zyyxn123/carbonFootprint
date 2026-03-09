import { dataPanelComponent } from "../Component/dataPanelComponent"
import { gaugeComponent } from "../Component/gaugeComponent"

@Component
export struct carbonLevelView {
  build() {
    Row({ space: 15 }) {
      Column({ space: 15 }) {
        Text($r('app.string.carbonLevel_carbonEmission'))
          .fontColor($r('app.color.carbonLevel_carbonEmission_color'))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10 })

        gaugeComponent()
          .backgroundColor(Color.White)
          .padding(5)
          .borderRadius(25)
      }
      .width('48%')
      .height('30%')
      .backgroundColor($r('app.color.carbonLevel_carbonEmission_background'))
      .borderRadius(25)
      .shadow({ radius: 25, color: '#000000', type: ShadowType.BLUR })
      .backgroundBlurStyle(BlurStyle.Thin,
        { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 1.0 })

      Column({ space: 10 }) {
        Column({ space: 5 }) {
          Text($r('app.string.carbonLevel_carbonEmissionLevel'))
            .fontColor($r('app.color.carbonLevel_carbonEmission_color'))
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 10 })

          dataPanelComponent()
        }
        .width('48%')
        .height('22%')
        .backgroundColor($r('app.color.carbonLevel_carbonEmission_background'))
        .borderRadius(25)
        .shadow({ radius: 25, color: '#000000', type: ShadowType.BLUR })
        .backgroundBlurStyle(BlurStyle.Thin,
          { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 1.0 })

        Row() {
          Text('今日摊牌减少15%')
            .fontColor(Color.Black)
            .fontSize(14)
            .margin(6)
        }
        .height('6%')
        .width(160)
        .borderRadius(15)
        .alignItems(VerticalAlign.Center)
        .backgroundColor($r('app.color.carbonLevel_carbonEmission_background'))
        // .backgroundBlurStyle(BlurStyle.Thin,
        //   { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 1.0 })
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .padding({ left: 10, right: 10 })
  }
}