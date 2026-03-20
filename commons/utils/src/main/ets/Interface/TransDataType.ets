export interface TransTotalDataType {
  id: number,
  account: string,
  total_emission: number,
  total_day: number,
  monthly_emission: number,
  monthly_order: number,
  monthly_distance: number,
  point: number,
  medal: number,
  time_token: string
}

export interface TransItemDataType {
  id: number,
  account: string,
  transport: string,
  mileage: number,
  trip_time: number,
  time_token: string,
  carbon_emission: number
}