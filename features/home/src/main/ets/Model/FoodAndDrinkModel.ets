import { CarEmiFoodTable, FoodItemDataType, FoodTotalDataType } from "@ohos/utils"

export class FoodDataModel {
  static foodIns: CarEmiFoodTable = CarEmiFoodTable.getInstance()

  public static async getTotalData(acc: string) {
    const dataItem: FoodTotalDataType = await FoodDataModel.foodIns.getFoodTotalData(acc)
    return dataItem
  }

  public static async getFoodItemData(acc: string) {
    const dataItem: FoodItemDataType[] = await FoodDataModel.foodIns.getFoodItemData(acc)
    return dataItem
  }

  public static async updateTotalData(data: FoodTotalDataType) {
    await FoodDataModel.foodIns.updateTotalData(data)
  }

  public static async updateItemData(acc: string, food: string, eat_portion: number,
    eat_time: number, time_token: string, carbon_emission: number) {
    await FoodDataModel.foodIns.insertItemData(acc, food, eat_portion,
      eat_time, time_token, carbon_emission)
  }
}