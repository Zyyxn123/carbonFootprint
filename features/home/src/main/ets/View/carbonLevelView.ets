import { dataPanelComponent } from "../Component/dataPanelComponent"
import { gaugeComponent } from "../Component/gaugeComponent"
import CarLevVM from "../ViewModel/CarLevelViewModel"

let date = new Date().toLocaleDateString()

@Component
export struct carbonLevelView {
  @StorageLink('currLoginAcc') acc: string = ''

  async aboutToAppear(): Promise<void> {
    await CarLevVM.getTotalData(this.acc, date)
  }

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
          .height(190)
      }
      .width('48%')
      .height(222)
      .backgroundColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_background'))
      .borderRadius(25)

      /**
       * 等级评分
       */
        Column({ space: 5 }) {
          Text($r('app.string.carbonLevelView_carbonEmissionLevel'))
            .fontColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_color'))
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 10 })

          dataPanelComponent()
        }
        .width('48%')
        .height(222)
        .backgroundColor($r('app.color.carbonLevelView_carbonEmissionAndLevel_background'))
        .borderRadius(15)
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .padding({ left: 10, right: 10 })
  }
}