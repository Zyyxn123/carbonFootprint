import { additionalInfo } from "../View/AdditionalInfo"
import { carbonFootprintTitle } from "../View/CarbonFootprintTitle"
import { carbonLineChart } from "../View/carbonLineChart"
import { carbonRecordAndTasks } from "../View/CarbonRecordAndTasks"
import { reduceCarbonEmission } from "../View/ReduceCarbonEmission"
import mapFootVM from "../ViewModel/MapFootprintViewModel"

@Component
export struct tendency_homePage {
  private tabCtrl: TabsController = new TabsController()

  async aboutToAppear(): Promise<void> {
    const acc: string = AppStorage.get('currLoginAcc') as string
    await mapFootVM.getItemData(acc)
  }

  build() {
    Column({ space: 13 }) {
      carbonFootprintTitle()
      carbonRecordAndTasks()
      carbonLineChart()
      additionalInfo()
      // reduceCarbonEmission()
    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 10 })
  }
}