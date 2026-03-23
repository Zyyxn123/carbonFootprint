import { CarEmiTotalWeeklyTable, WeeklyTotalDataType } from "@ohos/utils";

export class CarLevelModel {
  static totalWeeklyIns: CarEmiTotalWeeklyTable = CarEmiTotalWeeklyTable.getInstance()

  public static async getTodayData(acc: string, date: string) {
    const dataItem: WeeklyTotalDataType = await CarLevelModel.totalWeeklyIns.getWeeklyTotalData(acc, date)
    return dataItem
  }

  public static async updateData(data: WeeklyTotalDataType, date: string) {
    await CarLevelModel.totalWeeklyIns.updateTotalData(data, date)
  }
}