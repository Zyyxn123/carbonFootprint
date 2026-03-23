export interface WeeklyTotalDataType {
  id: number,
  account: string,
  record_date: string,
  travel_carbon: number,
  electric_carbon: number,
  food_carbon: number,
  total_carbon: number,
  current_week_daily_carbon: string,
  last_week_daily_carbon: string
}