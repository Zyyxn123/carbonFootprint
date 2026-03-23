import { CarEmiTotalWeeklyTable, WeeklyTotalDataType } from "@ohos/utils";

export class LineChartModel {
  static totalWeeklyIns: CarEmiTotalWeeklyTable = CarEmiTotalWeeklyTable.getInstance()

  public static async getTodayData(acc: string, date: string) {
    const dataItem: WeeklyTotalDataType = await LineChartModel.totalWeeklyIns.getWeeklyTotalData(acc, date)
    return dataItem
  }

  public static async updateData(data: WeeklyTotalDataType, date: string) {
    await LineChartModel.totalWeeklyIns.updateTotalData(data, date)
  }
}