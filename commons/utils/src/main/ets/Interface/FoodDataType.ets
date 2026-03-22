export interface FoodItemDataType {
  id: number,
  account: string,
  food: string,
  eat_portion: number,
  eat_time: number,
  time_token: string,
  carbon_emission: number
}

export interface FoodTotalDataType {
  id: number,
  account: string,
  total_emission: number,
  total_day: number,
  monthly_emission: number,
  monthly_order: number,
  monthly_portion: number,
  point: number,
  medal: number,
  time_token: string
}