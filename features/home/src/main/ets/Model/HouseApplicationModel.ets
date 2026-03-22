import { ApplianceTotalDataType, CarEmiApplianceTable } from "@ohos/utils"

// export interface applicationsTypeModel {
//   bgc: string
//   tsc: string
//   ts: string
//   img: ResourceStr
// }
//
// export interface applicationsPopBoxDataTypeModel {
//   text: string
//   num: number
//   unit?: string
//   img?: ResourceStr
// }
//
// export interface applicationsCardsDataTypeModel {
//   text: string
//   num: number
//   unit?: string
//   img?: ResourceStr
// }

export class ApplianceDataModel {
  static applianceIns: CarEmiApplianceTable = CarEmiApplianceTable.getInstance()

  public static async getTotalData(acc: string) {
    const dataItem: ApplianceTotalDataType = await ApplianceDataModel.applianceIns.getApplianceTotalData(acc)
    return dataItem
  }

  public static async updateTotalData(data: ApplianceTotalDataType) {
    await ApplianceDataModel.applianceIns.updateTotalData(data)
  }

  public static async insertItemData(acc: string, appliance: string, use_time: number,
    elect_power: number, time_token: string, carbon_emission: number) {
    await ApplianceDataModel.applianceIns.insertItemData(acc, appliance, use_time,
      elect_power, time_token, carbon_emission)
  }
}