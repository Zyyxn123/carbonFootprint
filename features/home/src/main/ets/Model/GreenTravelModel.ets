import { CarEmiTransTable, TransItemDataType, TransTotalDataType } from "@ohos/utils"

export class TransDataModel {
  static TransIns: CarEmiTransTable = CarEmiTransTable.getInstance()

  public static async getTotalData(acc: string) {
    const dataItem: TransTotalDataType = await TransDataModel.TransIns.getTransTotalData(acc)
    return dataItem
  }

  public static async getTransItemData(acc: string) {
    const dataItem: TransItemDataType[] = await TransDataModel.TransIns.getTransItemData(acc)
    return dataItem
  }

  public static async updateTotalData(data: TransTotalDataType) {
    await TransDataModel.TransIns.updateTotalData(data)
  }

  public static async updateItemData(acc: string, transport: string, mileage: number,
    trip_time: number, time_token: string, carbon_emission: number) {
    await TransDataModel.TransIns.insertItemData(acc, transport, mileage,
      trip_time, time_token, carbon_emission)
  }
}