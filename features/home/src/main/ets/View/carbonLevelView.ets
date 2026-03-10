import { dataPanelComponent } from "../Component/dataPanelComponent"
import { gaugeComponent } from "../Component/gaugeComponent"

@Component
export struct carbonLevelView {
  build() {
    Row({ space: 15 }) {
      Column({ space: 15 }) {
        Text($r('app.string.carbonLevelView_carbonEmission'))
          .fontColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_color'))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10 })

        gaugeComponent()
          .backgroundColor($r('app.color.carbonLevelView_data_background'))
          .padding(5)
          .borderRadius(25)
      }
      .width('48%')
      .height('30%')
      .backgroundColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_background'))
      .borderRadius(25)

      Column({ space: 10 }) {
        Column({ space: 5 }) {
          Text($r('app.string.carbonLevelView_carbonEmissionLevel'))
            .fontColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_color'))
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 10 })

          dataPanelComponent()
        }
        .width('48%')
        .height('22%')
        .backgroundColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_background'))
        .borderRadius(25)

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