import { CarEmiFoodTable, FoodTotalDataType } from "@ohos/utils"

// export interface foodAndDrinkTypeModel {
//   bgc: string
//   tsc: string
//   ts: string
//   img: ResourceStr
// }
//
// export interface foodAndDrinkCardsDataTypeModel {
//   text: string
//   num: number
//   unit?: string
//   img?: ResourceStr
// }
//
// export interface foodAndDrinkPopBoxDataTypeModel {
//   text: string
//   num: number
//   unit?: string
//   img?: ResourceStr
// }

export class FoodDataModel {
  static foodIns: CarEmiFoodTable = CarEmiFoodTable.getInstance()

  public static async getTotalData(acc: string) {
    const dataItem: FoodTotalDataType = await FoodDataModel.foodIns.getFoodTotalData(acc)
    return dataItem
  }

  public static async updateTotalData(data: FoodTotalDataType) {
    await FoodDataModel.foodIns.updateTotalData(data)
  }

  public static async insertItemData(acc: string, food: string, eat_portion: number,
    eat_time: number, time_token: string, carbon_emission: number) {
    await FoodDataModel.foodIns.insertItemData(acc, food, eat_portion,
      eat_time, time_token, carbon_emission)
  }
}