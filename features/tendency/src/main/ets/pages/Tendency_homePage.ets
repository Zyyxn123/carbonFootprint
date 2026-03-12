import { additionalInfo } from "../View/AdditionalInfo"
import { carbonFootprintTitle } from "../View/CarbonFootprintTitle"
import { carbonLineChart } from "../View/carbonLineChart"
import { carbonRecordAndTasks } from "../View/CarbonRecordAndTasks"
import { reduceCarbonEmission } from "../View/ReduceCarbonEmission"

@Component
export struct tendency_homePage {
  private tabCtrl: TabsController = new TabsController()

  build() {
    Column({ space: 15 }) {
      carbonFootprintTitle()
      carbonRecordAndTasks()
      carbonLineChart()
      additionalInfo()
      reduceCarbonEmission()
    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 10 })
  }
}