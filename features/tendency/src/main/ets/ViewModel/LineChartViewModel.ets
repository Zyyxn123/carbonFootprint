import { WeeklyTotalDataType } from "@ohos/utils"
import { LineChartModel } from "../Model/LineChartModel"
import { LineChartArrayType } from "../Type/LineChartArrayType"

@ObservedV2
class LineChartViewModel {
  @Trace currTotalWeeklyCarbon: number[] | string = ''
  @Trace current_week_daily_carbon: string = '[0,0,0,0,0,0,0]'
  @Trace last_week_daily_carbon: string = '[0,0,0,0,0,0,0]'
  @Trace acc: string = AppStorage.get('currLoginAcc') as string

  public async getTotalData(acc: string, date: string) {
    const dataItem: WeeklyTotalDataType = await LineChartModel.getTodayData(acc, date)
    this.current_week_daily_carbon = dataItem.current_week_daily_carbon || '[0,0,0,0,0,0,0]'
    this.last_week_daily_carbon = dataItem.last_week_daily_carbon || '[0,0,0,0,0,0,0]'
    this.currTotalWeeklyCarbon = this.safeParseCarbonArray(LineCVM.current_week_daily_carbon)
  }

  /**
   * 工具方法：安全解析JSON字符串为数字数组（核心保障数组类型）
   * @param jsonStr JSON字符串
   * @returns 标准数字数组（长度7，默认0）
   */
  private safeParseCarbonArray(jsonStr: string): number[] {
    try {
      // 1. 解析JSON
      const parsed: number[] = JSON.parse(jsonStr) as number[]
      // 2. 校验是否为数组
      if (!Array.isArray(parsed)) {
        console.warn('解析结果不是数组，使用默认值')
        return [0, 0, 0, 0, 0, 0, 0]
      }
      // 3. 转换为数字数组，长度补全/截断为7
      const numArray = parsed.map(item => Number(item) || 0) // 非数字转0
      while (numArray.length < 7) {
        numArray.push(0) // 长度不足补0
      }
      while (numArray.length > 7) {
        numArray.pop() // 长度超出截断
      }
      return numArray
    } catch (e) {
      console.error('解析碳排量数组失败：', e)
      return [0, 0, 0, 0, 0, 0, 0] // 解析失败返回默认数组
    }
  }
}

const LineCVM: LineChartViewModel = new LineChartViewModel()

export default LineCVM