import {
  ApplianceItemDataType,
  ApplianceTotalDataType,
  CarEmiApplianceTable,
  CarEmiFoodTable,
  CarEmiTotalWeeklyTable,
  CarEmiTransTable,
  FoodItemDataType,
  FoodTotalDataType,
  TransItemDataType,
  TransTotalDataType,
  WeeklyTotalDataType
} from "@ohos/utils"


export class ReduceEmiModel {
  static TransIns: CarEmiTransTable = CarEmiTransTable.getInstance()
  static applianceIns: CarEmiApplianceTable = CarEmiApplianceTable.getInstance()
  static foodIns: CarEmiFoodTable = CarEmiFoodTable.getInstance()
  static totalWeeklyIns: CarEmiTotalWeeklyTable = CarEmiTotalWeeklyTable.getInstance()

  public static async getTodayTotalData(acc: string, date: string) {
    const dataItem: WeeklyTotalDataType = await ReduceEmiModel.totalWeeklyIns.getWeeklyTotalData(acc, date)
    return dataItem
  }

  public static async getTransTotalData(acc: string) {
    const dataItem: TransTotalDataType = await ReduceEmiModel.TransIns.getTransTotalData(acc)
    return dataItem
  }

  public static async getTransItemData(acc: string) {
    const dataItem: TransItemDataType[] = await ReduceEmiModel.TransIns.getTransItemData(acc)
    return dataItem
  }

  public static async getAppsTotalData(acc: string) {
    const dataItem: ApplianceTotalDataType = await ReduceEmiModel.applianceIns.getApplianceTotalData(acc)
    return dataItem
  }

  public static async getAppsItemData(acc: string) {
    const dataItem: ApplianceItemDataType[] = await ReduceEmiModel.applianceIns.getApplianceItemData(acc)
    return dataItem
  }

  public static async getFoodTotalData(acc: string) {
    const dataItem: FoodTotalDataType = await ReduceEmiModel.foodIns.getFoodTotalData(acc)
    return dataItem
  }

  public static async getFoodItemData(acc: string) {
    const dataItem: FoodItemDataType[] = await ReduceEmiModel.foodIns.getFoodItemData(acc)
    return dataItem
  }
}