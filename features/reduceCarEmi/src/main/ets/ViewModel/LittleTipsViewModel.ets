import { redEmiRecType } from "../Model/LittleTipsModel"
import tipsModel from "../Model/LittleTipsModel"

@ObservedV2
class LittleTipsViewModel {
  @Trace displayArray: redEmiRecType[] = []

  public getTodayRandomTips() {
    this.displayArray = tipsModel.getRandomTips()
    for (let index = 0; index < this.displayArray.length; index++) {
      console.log(`getTodayRandomTips${index}: ${this.displayArray[index].id}`)
      console.log(`getTodayRandomTips${index}: ${this.displayArray[index].recMeasure}`)
      console.log(`getTodayRandomTips${index}: ${this.displayArray[index].emiRedEffect}`)
      console.log(`getTodayRandomTips${index}: ${this.displayArray[index].adaptOffer}`)
    }
  }
}

const tipsVM = new LittleTipsViewModel()

export default tipsVM