import { WeeklyTotalDataType } from "@ohos/utils"
import { CarLevelModel } from "../Model/CarLevelModel"
import { CarLevelArrayType } from "../Type/CarLevelArrayType"

@ObservedV2
class CarLevelViewModel {
  @Trace dataPanelVals: number[] = [0, 0, 0]
  @Trace id: number = -1
  @Trace account: string = ''
  @Trace record_date: string = ''
  @Trace travel_carbon: number = 0.0
  @Trace electric_carbon: number = 0.0
  @Trace food_carbon: number = 0.0
  @Trace total_carbon: number = 0.0
  @Trace current_week_daily_carbon: string = '[0,0,0,0,0,0,0]'
  @Trace last_week_daily_carbon: string = '[0,0,0,0,0,0,0]'
  @Trace acc: string = AppStorage.get('currLoginAcc') as string

  public async getTotalData(acc: string, date: string) {
    const dataItem: WeeklyTotalDataType = await CarLevelModel.getTodayData(acc, date)
    this.id = dataItem.id
    this.account = dataItem.account
    this.record_date = dataItem.record_date
    this.travel_carbon = dataItem.travel_carbon
    this.electric_carbon = dataItem.electric_carbon
    this.food_carbon = dataItem.food_carbon
    this.total_carbon = dataItem.total_carbon
    this.current_week_daily_carbon = dataItem.current_week_daily_carbon || '[0,0,0,0,0,0,0]'
    this.last_week_daily_carbon = dataItem.last_week_daily_carbon || '[0,0,0,0,0,0,0]'

    this.dataPanelVals = [
      Number(this.travel_carbon.toFixed(2)),
      Number(this.electric_carbon.toFixed(2)),
      Number(this.food_carbon.toFixed(2))
    ]

    // 首次加载时，先检查是否需要周切换
    this.checkWeekSwitch()
  }

  /**
   * 关键判断逻辑：是否到了新一周（周一），触发数组更迭
   * 规则：当当日是周一（weekIndex=0）时，将本周数组 → 上周数组，本周数组重置为0
   */
  private checkWeekSwitch() {
    const date = new Date().toLocaleDateString()
    const weekData = this.getWeekdayFromMDY(date)
    if (!weekData) return
    console.log('CarLevelViewModel: ' + this.last_week_daily_carbon)
    console.log('CarLevelViewModel: ' + this.current_week_daily_carbon)
    console.log('CarLevelViewModel: ' + weekData.weekIndex)
    let b = this.current_week_daily_carbon !== '[0,0,0,0,0,0,0]'
    console.log('CarLevelViewModel: ' + b)

    // 判断：如果是周一（weekIndex=0），且本周数组不是初始值（避免重复切换）
    if (weekData.weekIndex === 0 && this.current_week_daily_carbon !== '[0,0,0,0,0,0,0]') {
      // 1. 本周数组 → 上周数组（完成更迭）
      this.last_week_daily_carbon = this.current_week_daily_carbon
      // 2. 本周数组重置为全0（新一周开始）
      this.current_week_daily_carbon = '[0,0,0,0,0,0,0]'
      console.log('CarLevelViewModel1: ' + this.last_week_daily_carbon)
      console.log('CarLevelViewModel1: ' + this.current_week_daily_carbon)
    }
  }

  public updateData(index: number, carEmi: number) {
    const fixedCarEmi = Number(carEmi.toFixed(2))

    if (index === 1) {
      this.travel_carbon = Number((this.travel_carbon + fixedCarEmi).toFixed(2))
    } else if (index === 2) {
      this.electric_carbon = Number((this.electric_carbon + fixedCarEmi).toFixed(2))
    } else if (index === 3) {
      this.food_carbon = Number((this.food_carbon + fixedCarEmi).toFixed(2))
    }
    this.total_carbon = Number((this.total_carbon + fixedCarEmi).toFixed(2))

    this.updatePanelVals(index, fixedCarEmi)

    this.updateArray(this.total_carbon)

    this.saveToDB()
  }

  private updatePanelVals(index: number, carEmi: number) {
    // 先复制当前值，避免直接修改原数组
    let temp1: number = this.dataPanelVals[0]
    let temp2: number = this.dataPanelVals[1]
    let temp3: number = this.dataPanelVals[2]

    if (index === 1) {
      temp1 = Number((temp1 + carEmi).toFixed(2)) // 保留1位小数
    } else if (index === 2) {
      temp2 = Number((temp2 + carEmi).toFixed(2)) // 保留1位小数
    } else if (index === 3) {
      // 修复原代码bug：index=3时错误赋值为carEmi，应该是temp3 + carEmi
      temp3 = Number((temp3 + carEmi).toFixed(2)) // 保留1位小数
    }

    // 重新赋值，确保所有元素都是1位小数
    this.dataPanelVals = [
      Number(temp1.toFixed(2)),
      Number(temp2.toFixed(2)),
      Number(temp3.toFixed(2))
    ]
    console.log('CarLevelViewModel3: ' + this.dataPanelVals.toString())
  }

  /**
   * 核心：更新本周数组 + 判断是否需要切换周（本周→上周）
   * @param carEmi: 当日总碳排量
   */
  private updateArray(carEmi: number) {
    // 1. 解析当前日期，获取本周索引
    const date = new Date().toLocaleDateString()
    const weekData = this.getWeekdayFromMDY(date)
    if (!weekData) return

    // 2. 先检查是否需要周切换（比如周一，要把上周数据归档）
    this.checkWeekSwitch()

    // 3. 解析本周数组，更新对应索引的值
    let currentWeekArr: number[] = JSON.parse(this.current_week_daily_carbon) as number[]
    // 确保数组长度为7（容错）
    if (currentWeekArr.length !== 7) {
      currentWeekArr = [0,0,0,0,0,0,0]
    }
    // 更新当日碳排量到数组对应位置
    currentWeekArr[weekData.weekIndex] = carEmi
    // 存回字符串（供数据库存储）
    this.current_week_daily_carbon = JSON.stringify(currentWeekArr)
    console.log('CarLevelViewModel2: ' + this.current_week_daily_carbon)
  }

  private getWeekdayFromMDY(dateStr: string): CarLevelArrayType | null {
    // 1. 拆分字符串（按 / 分割）
    const parts = dateStr.split('/');
    if (parts.length !== 3) {
      console.error('日期格式错误，需为 MM/DD/YYYY，如 "2/2/2026"');
      return null
    }

    // 2. 转换为数字（处理单数字月份/日期，如 "2/2/2026" → 2,2,2026）
    const month = parseInt(parts[0], 10)
    const day = parseInt(parts[1], 10)
    const year = parseInt(parts[2], 10)

    // 3. 校验数字有效性
    if (isNaN(month) || isNaN(day) || isNaN(year)
      || month < 1 || month > 12
      || day < 1 || day > 31) {
      console.error('日期数值无效：', dateStr)
      return null
    }

    // 4. 计算星期
    const date = new Date(year, month - 1, day) // 月份减1（Date对象月份0~11）
    const weekDay = date.getDay() // 0=周日, 1=周一, ... , 6=周六

    // 5. 转换为折线图需要的本周索引（周一=0，周日=6）
    const weekIndex = weekDay === 0 ? 6 : weekDay - 1

    // 6. 转换为中文星期
    const weekCnList = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
    const weekCn = weekCnList[weekDay]

    return { weekDay, weekIndex, weekCn }
  }

  /**
   * 持久化数据到数据库（修改后必须保存，否则刷新后丢失）
   */
  private async saveToDB() {
    try {
      const updateData: WeeklyTotalDataType = {
        id: this.id,
        account: this.account,
        record_date: this.record_date,
        travel_carbon: this.travel_carbon,
        electric_carbon: this.electric_carbon,
        food_carbon: this.food_carbon,
        total_carbon: this.total_carbon,
        current_week_daily_carbon: this.current_week_daily_carbon,
        last_week_daily_carbon: this.last_week_daily_carbon
      }
      // 调用Model层的更新方法（需确保CarLevelModel有update方法）
      await CarLevelModel.updateData(updateData, this.record_date)
      console.log('碳数据+周数组更新到数据库成功')
    } catch (error) {
      console.error('数据持久化失败：', error)
    }
  }
}

const CarLevVM: CarLevelViewModel = new CarLevelViewModel()

export default CarLevVM