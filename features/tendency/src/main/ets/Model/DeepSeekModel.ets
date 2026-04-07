import { HTTPForAI_deepSeek } from "@ohos/utils"


export class DeepSeekModel {
  static httpForDeepSeekIns: HTTPForAI_deepSeek = HTTPForAI_deepSeek.getInstance()

  public static async getQuesData(ques: string) {
    await DeepSeekModel.httpForDeepSeekIns.httpForAns(ques)
  }
}

export interface dataType {
  que: string
  ans: string
}