export interface transportsTypeModel {
  bgc: string
  tsc: string
  bgcCard: string  // 新增：比 tsc 更浅的卡片背景色
  ts: string
  img: ResourceStr
  carEmissionPer: number
  pointsPerOrder: number
}

export interface popBoxDataTypeModel {
  text: string
  num: number
  unit?: string
  img?: ResourceStr
}

export interface cardsDataTypeModel {
  text: string
  num: number
  unit?: string
  img?: ResourceStr
}