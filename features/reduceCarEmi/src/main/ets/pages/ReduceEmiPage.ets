import { AIReport } from "../View/AIReport"
import { DataSummary } from "../View/DataSummary"
import { LittleTips } from "../View/LittleTips"
import tipsVM from "../ViewModel/LittleTipsViewModel"

@Component
export struct ReduceEmiPage {
  aboutToAppear(): void {
    tipsVM.getTodayRandomTips()
  }

  build() {
    List() {
      DataSummary()

      /**
       * @todo: 后续完善 ai 功能
       */
      AIReport()

      LittleTips()

      // myGrid()

      ListItem() {
        Column()
          .width('100%')
          .height(80)
      }
    }
    .height('100%')
    .width('100%')
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
  }
}
