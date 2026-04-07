import { HTTPForAI_deepSeek } from "@ohos/utils"
import { dataType, DeepSeekModel } from "../Model/DeepSeekModel"


@ObservedV2
class DeepSeekViewModel {
  @Trace dataList: dataType[] = []
  @Trace currQues: string = ''
  @Trace currAns: string = ''
  private httpForDSIns: HTTPForAI_deepSeek = HTTPForAI_deepSeek.getInstance()

  public async getQues(ques: string) {
    await DeepSeekModel.getQuesData(ques)
    const dataItem: dataType = {
      que: ques,
      ans: ''
    }

    this.currQues = ques
    const timeId = setInterval(() => {
      dataItem.ans = this.httpForDSIns.returnData
      this.currAns = this.httpForDSIns.returnData.replace("[DONE]", "").trim()

      if (this.httpForDSIns.isOK) {
        dataItem.ans = dataItem.ans.replace("[DONE]", "").trim()
        this.dataList.push(dataItem)
        this.currQues = ''
        this.currAns = ''
        this.httpForDSIns.returnData = ''
        this.httpForDSIns.isOK = false
        clearInterval(timeId)
      }
    }, 600)
    for (let index = 0; index < this.dataList.length; index++) {
      const element = this.dataList[index]
      console.log(`DeepSeekViewModel${index}: ` +
       JSON.stringify(element))
    }

  }
}

const dpVM: DeepSeekViewModel = new DeepSeekViewModel()

export default dpVM