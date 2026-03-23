export interface LineChartArrayType {
  weekDay: number,    // 0=周日,1=周一,...,6=周六
  weekIndex: number,  // 周一=0,周二=1,...,周日=6（适配折线图数组索引）
  weekCn: string      // 中文星期：如 "周一"、"周日"
}