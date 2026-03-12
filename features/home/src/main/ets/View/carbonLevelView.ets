import { dataPanelComponent } from "../Component/dataPanelComponent"
import { gaugeComponent } from "../Component/gaugeComponent"

@Component
export struct carbonLevelView {
  build() {
    Row({ space: 15 }) {
      /**
       * 总碳耗量
       */
      Column({ space: 5 }) {
        Text($r('app.string.carbonLevelView_carbonEmission'))
          .fontColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_color'))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10 })

        gaugeComponent()
          .backgroundColor($r('app.color.carbonLevelView_data_background'))
          .padding(3)
          .borderRadius(25)
      }
      .width('48%')
      .height('32%')
      .backgroundColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_background'))
      .borderRadius(25)

      /**
       * 等级评分
       */
      Column({ space: 5 }) {
        Column({ space: 5 }) {
          Text($r('app.string.carbonLevelView_carbonEmissionLevel'))
            .fontColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_color'))
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 10 })

          dataPanelComponent()
        }
        .width('48%')
        .height('25%')
        .backgroundColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_background'))
        .borderRadius(15)

        /**
         * 目前减碳增量（对比昨天）
         */
        Row() {
          Text($r('app.string.carbonLevelView_carbonEmissionReduce'))
            .fontColor(Color.Black)
            .fontSize(14)
            .margin(6)
        }
        .height('6%')
        .width(160)
        .borderRadius(15)
        .alignItems(VerticalAlign.Center)
        .backgroundColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_background'))
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .padding({ left: 10, right: 10 })
  }
}