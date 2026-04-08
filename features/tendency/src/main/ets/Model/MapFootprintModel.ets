import { MapFootDataType, TendMapFootTable } from "@ohos/utils"


export class MapFootprintModel {
  static tendMapFootIns: TendMapFootTable = TendMapFootTable.getInstance()

  public static async getItemData(acc: string, date: string) {
    const dataItem: MapFootDataType[] = await MapFootprintModel.tendMapFootIns.getItemData(acc)
    return dataItem
  }

  public static async insertItemData(acc: string, recordDate: string,
    data: string, extraData: string, carEmi: number) {
    await MapFootprintModel.tendMapFootIns.insertItemData(acc, recordDate,
      data, extraData, carEmi)
  }
}