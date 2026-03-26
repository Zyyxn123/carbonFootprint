import { PieChartData } from "@abner/pie";
import reduceEmiVM from "./ReduceEmiViewModel";

@ObservedV2
class DataSumViewModel {
  // 统计天数
  @Trace sortList: number[] = [3, 7, 14]
  // 总碳排放量
  @Trace totalCarEmi: number = 0
  @Trace todayTotalCarEmi: number = 0
  // 日均碳排放量
  @Trace EmiAverage: number = 0
  // 全国人均日均碳排放量kg
  @Trace personAverage: number = 22.1
  // 是否高于全国人均：true=高于，false=低于
  @Trace isHigh: boolean = false
  @Trace aiEstimateEmi: number = 32.8
  private carbonLevelConfigs: LevConfigType[] = [
    {
      min: 0,
      max: 12,
      name: "低碳先锋",
      color: "#059669",
      level: 5
    },
    {
      min: 12,
      max: 20,
      name: "环保节能",
      color: "#10B981",
      level: 4
    },
    {
      min: 20,
      max: 28,
      name: "标准适中",
      color: "#D97706",
      level: 3
    },
    {
      min: 28,
      max: 36,
      name: "减排预警",
      color: "#EA580C",
      level: 2
    },
    {
      min: 36,
      max: 999,
      name: "高碳警示",
      color: "#DC2626",
      level: 1
    }
  ]
  @Trace showLevel: LevConfigType = {
    min: 0,
    max: 12,
    name: "低碳先锋",
    color: "#059669",
    level: 5
  }
  @Trace chartData: PieChartData[] = [
    { label: "交通", value: 50, color: "#37800f" },
    { label: "电器", value: 30, color: "#65ff00dd" },
    { label: "饮食", value: 20, color: "#65ffe600" }
  ]

  private async getThreeItemData(index: number, acc: string): Promise<void> {
    if (index < 0 || index >= this.sortList.length) {
      return
    }

    const days = this.sortList[index]

    const trans = await reduceEmiVM.getCustomDaysTransEmission(acc, days)
    const appliance = await reduceEmiVM.getCustomDaysApplianceEmission(acc, days)
    const food = await reduceEmiVM.getCustomDaysFoodEmission(acc, days)

    this.chartData = [
      { label: "交通", value: Number(trans.toFixed(1)), color: "#37800f" },
      { label: "电器", value: Number(appliance.toFixed(1)), color: "#65ff00dd" },
      { label: "饮食", value: Number(food.toFixed(1)), color: "#65ffe600" }
    ];
  }

  /**
   * 根据总碳排获取对应等级配置的下标
   * @param totalCarbon 总碳排放量
   * @returns 匹配到的配置下标（0-4）
   */
  private getCarbonLevelIndex(totalCarbon: number): number {
    // 遍历配置，找到满足 min ≤ 碳排 < max 的项
    for (let i = 0; i < this.carbonLevelConfigs.length; i++) {
      const config = this.carbonLevelConfigs[i];
      if (totalCarbon >= config.min && totalCarbon < config.max) {
        this.showLevel = this.carbonLevelConfigs[i]
        return i
      }
    }
    this.showLevel = this.carbonLevelConfigs[this.carbonLevelConfigs.length - 1]
    // 兜底返回最高风险下标
    return this.carbonLevelConfigs.length - 1
  }

  /**
   * 功能1：根据下标设置总碳排放量 totalCarEmi
   * @param index sortList下标（0=7天，1=30天，2=90天）
   * @param acc 账号
   */
  private async setTotalCarEmi(acc: string, index: number): Promise<void> {
    if (index < 0 || index >= this.sortList.length) {
      return
    }

    const totalEmiData: Number =
      await reduceEmiVM.getCustomDaysTotalEmission(acc, this.sortList[index])
    this.totalCarEmi = Number(totalEmiData.toFixed(1))
    console.log('DataSumViewModel1:' + this.totalCarEmi)
  }

  /**
   * 功能1：设置今日总碳排放量 todayTotalCarEmi
   * @param acc 账号
   */
  private async setTodayTotalCarEmi(acc: string) {
    this.todayTotalCarEmi = await reduceEmiVM.getTodayTotalEmission(acc)
  }

  /**
   * 功能2：根据下标计算日均碳排 EmiAverage = 总碳排 / 对应天数
   * @param index sortList下标
   */
  private calculateEmiAverage(index: number): void {
    if (index < 0 || index >= this.sortList.length) {
      return
    }

    const days = this.sortList[index]
    const average = days > 0 ? this.totalCarEmi / days : 0
    this.EmiAverage = Number(average.toFixed(1))
    console.log('DataSumViewModel2:' + this.EmiAverage)
  }

  /**
   * 功能4：比较日均碳排与全国人均，赋值isHigh
   * @param index sortList下标
   */
  private compareWithNationalAverage(): void {
    this.isHigh = this.EmiAverage > this.personAverage
    console.log('DataSumViewModel3:' + this.isHigh)
  }

  /**
   * 【整合方法】推荐使用：一步完成 赋值总排→计算日均→对比人均
   * @param index 天数下标
   * @param totalValue 对应天数的总碳排放量
   */
  async updateAllData(index: number, acc: string): Promise<void> {
    await this.setTodayTotalCarEmi(acc)
    await this.setTotalCarEmi(acc, index)
    await this.getThreeItemData(index, acc)
    this.calculateEmiAverage(index)
    this.compareWithNationalAverage()
    this.getCarbonLevelIndex(this.todayTotalCarEmi)
  }
}

const dataSumVM: DataSumViewModel = new DataSumViewModel()

export default dataSumVM

export interface LevConfigType {
  min: number
  max: number
  name: string
  color: string
  level: number
}
