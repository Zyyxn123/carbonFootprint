import { ApplianceItemDataType, FoodItemDataType, HTTPForAIReport,
  ReduceCarEmiPreference,
  TransItemDataType } from '@ohos/utils'
import { ReduceEmiModel } from '../Model/ReduceEmiModel'
import reduceEmiVM from './ReduceEmiViewModel'
import { JSON } from '@kit.ArkTS'

@ObservedV2
class AIReportViewModel {
  @Trace showTextStr: string = ''
  @Trace isOk: boolean = false
  private httpForAIIns: HTTPForAIReport = HTTPForAIReport.getInstance()
  private redCarEmiPre: ReduceCarEmiPreference = ReduceCarEmiPreference.getInstance()

  /**
   * 计算 剩余可请求天数（0 = 可以请求）
   * 格式 3/24/2026 月/日/年
   */
  private getRemainingDays(): number {
    try {
      const savedDateStr = this.redCarEmiPre.getTodayTime()
      if (!savedDateStr) return 0 // 无记录，可直接请求

      // 解析保存的日期
      const savedParts = savedDateStr.split('/')
      const savedMonth = parseInt(savedParts[0]) - 1
      const savedDay = parseInt(savedParts[1])
      const savedYear = parseInt(savedParts[2])

      // 构建0点时间，避免小时影响
      const savedDate = new Date(savedYear, savedMonth, savedDay)
      const todayDate = new Date()
      const todayZero = new Date(todayDate.getFullYear(), todayDate.getMonth(), todayDate.getDate()).getTime()
      const savedZero = savedDate.getTime()

      // 已过天数
      const diffTime = todayZero - savedZero
      const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))

      // 剩余天数 = 7 - 已过天数
      const remain = 7 - diffDays
      return remain > 0 ? remain : 0

    } catch (e) {
      return 0
    }
  }

  /**
   * 把今天日期保存为：3/24/2026 格式
   */
  private updateTodayDateToDB() {
    try {
      const now = new Date()
      const month = now.getMonth() + 1
      const day = now.getDate()
      const year = now.getFullYear()
      const todayStr = `${month}/${day}/${year}`
      this.redCarEmiPre.setTodayTime(todayStr)
    } catch (e) {}
  }

  /**
   * 对外暴露：获取剩余天数
   */
  public getRemainRequestDays(): number {
    return this.getRemainingDays()
  }

  public async getMsg(acc: string) {
    this.redCarEmiPre.acc = acc
    const remainDays = this.getRemainingDays()

    // 剩余天数 > 0 → 不能请求
    if (remainDays > 0) {
      console.log(`未超过7天，剩余 ${remainDays} 天可再次请求`)
      this.showTextStr = this.redCarEmiPre.getData()
      return false
    }

    // 可以请求
    console.log('已超过7天，开始生成AI报告')
    this.showTextStr = ''
    this.isOk = false

    const tranData: TransItemDataType[] = await ReduceEmiModel.getTransItemData(acc)
    const appsData: ApplianceItemDataType[] = await ReduceEmiModel.getAppsItemData(acc)
    const foodData: FoodItemDataType[] = await ReduceEmiModel.getFoodItemData(acc)
    const msg: string = JSON.stringify(tranData) + JSON.stringify(appsData) + JSON.stringify(foodData)

    await this.httpForAIIns.httpForAIReport(msg)

    const timeID1 = setInterval(() => {
      this.showTextStr = this.httpForAIIns.returnTextStrData

      if (this.showTextStr.endsWith('[DONE]')) {
        this.isOk = true
        clearInterval(timeID1)
        this.showTextStr = this.showTextStr.replace('[DONE]', '')
        this.redCarEmiPre.setData(this.showTextStr)
        this.updateTodayDateToDB()
        console.log('报告完成，已更新日期')
      }
    }, 150)

    return true
  }
}

const aiReportVM: AIReportViewModel = new AIReportViewModel()

export default aiReportVM