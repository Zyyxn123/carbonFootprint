export interface ApplianceItemDataType {
  id: number,
  account: string,
  appliance: string,
  use_time: number,
  elect_power: number,
  time_token: string,
  carbon_emission: number
}

export interface ApplianceTotalDataType {
  id: number,
  account: string,
  total_emission: number,
  total_day: number,
  monthly_emission: number,
  monthly_order: number,
  monthly_degree: number,
  point: number,
  medal: number,
  time_token: string
}