import { HTTPForAIReport } from '@ohos/utils'

@ObservedV2
class AIReportViewModel {
  @Trace showTextStr: string = ''
  @Trace isOk: boolean = false
  private httpForAIIns: HTTPForAIReport = HTTPForAIReport.getInstance()


  public async getMsg() {
    await this.httpForAIIns.httpForAIReport()

    const timeID1 = setInterval(() => {
      this.showTextStr = this.httpForAIIns.returnTextStrData
      console.log('AIReportViewModel2:' + this.showTextStr)

      if (this.showTextStr.endsWith('[DONE]')) {
        this.isOk = true
        console.log('✅ 检测到 [DONE]，停止定时器')
        clearInterval(timeID1)
        this.showTextStr = this.showTextStr.replace('[DONE]', '')
      }
    }, 150)
  }
}

const aiReportVM: AIReportViewModel = new AIReportViewModel()

export default aiReportVM