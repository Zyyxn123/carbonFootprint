import { TasksDataType, TendTasksTable } from "@ohos/utils"


export class LowTaskModel {
  static tendTasksIns: TendTasksTable = TendTasksTable.getInstance()

  public static async getTodayData(acc: string, date: string) {
    const dataItem: TasksDataType = await LowTaskModel.tendTasksIns.getTodayTasksData(acc, date)
    return dataItem
  }

  public static updateData(data: TasksDataType, date: string) {
    LowTaskModel.tendTasksIns.updateTotalData(data, date)
  }
}