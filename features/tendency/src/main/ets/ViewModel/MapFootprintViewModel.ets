import { MapFootDataType } from "@ohos/utils"
import { MapFootprintModel } from "../Model/MapFootprintModel"
import { mapCommon } from "@kit.MapKit"

export interface dataSummaryType {
  recordDate: string
  acc: string
  data: mapCommon.PointAnnotationParams
  extraData: string
  carEmi: number
}

@ObservedV2
class MapFootprintViewModel {
  @Trace latelyData: dataSummaryType | undefined = undefined
  @Trace dataSummaryList: dataSummaryType[] = []

  public async getItemData(acc: string) {
    this.dataSummaryList = []
    let date = new Date().toLocaleDateString()
    const dataItem: MapFootDataType[] = await MapFootprintModel.getItemData(acc, date)

    for (const item of dataItem) {
      try {
        const parsedData: mapCommon.PointAnnotationParams =
          JSON.parse(item.data) as mapCommon.PointAnnotationParams

        const carEmiNumber = item.carEmi || 0
        const account = item.account
        const recordDate = item.recordDate

        const resultItem: dataSummaryType = {
          data: parsedData,
          acc: account,
          recordDate: recordDate,
          extraData: item.extraData || '',
          carEmi: carEmiNumber
        }
        this.dataSummaryList.push(resultItem)

      } catch (err) {
        console.error('JSON 解析失败：', err, '原始数据：', JSON.stringify(item))
      }
    }
    this.latelyData = this.dataSummaryList[this.dataSummaryList.length - 1]
  }

  public async insertItemData(acc: string, recordDate: string,
    data: mapCommon.PointAnnotationParams, extraData: string, carEmi: number) {
    const resultItem: dataSummaryType = {
      data: data,
      acc: acc,
      recordDate: recordDate,
      extraData: extraData || '',
      carEmi: carEmi
    }
    this.dataSummaryList.push(resultItem)

    const dataStr: string = JSON.stringify(data)
    await MapFootprintModel.insertItemData(acc, recordDate,
      dataStr, extraData, carEmi)
  }

  public getLatelyData() {
    this.latelyData = undefined
    this.latelyData = this.dataSummaryList[this.dataSummaryList.length - 1]
  }
}

const mapFootVM: MapFootprintViewModel = new MapFootprintViewModel()

export default mapFootVM
