import { ApplianceItemDataType, FoodItemDataType, TransItemDataType } from "@ohos/utils"
import { transportsTypeModel } from "../Model/ToDoItemsModel"

@Component
export struct funcListsCurrAction {
  @Prop index_page: number
  @Prop funcList: TransItemDataType[] | ApplianceItemDataType[] | FoodItemDataType[]
  @Prop bgcList: transportsTypeModel[]
  @Prop subHeading: string

  matchCorrBgc(data: TransItemDataType | ApplianceItemDataType | FoodItemDataType): transportsTypeModel | undefined {
    if (this.index_page === 1) {
      return this.bgcList
        .find(item => item.ts === (data as TransItemDataType).transport)
    } else if (this.index_page === 2) {
      return this.bgcList
        .find(item => item.ts === (data as ApplianceItemDataType).appliance)
    } else if (this.index_page === 3) {
      return this.bgcList
        .find(item => item.ts === (data as FoodItemDataType).food)
    }
    return undefined
  }

  @Builder
  timeTransItemListBuilder() {
    Column({ space: 8 }) {
      Text(this.subHeading)
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#000')
        .width('100%')
        .textAlign(TextAlign.Start)

      ForEach(this.funcList, (item: TransItemDataType, index: number) => {
        Row({ space: 20 }) {
          Image(this.matchCorrBgc(item)?.img)
            .width(40)
            .fillColor(this.matchCorrBgc(item)?.tsc)

          Text() {
            Span(item.transport + '   ')
              .fontSize(18)
              .fontColor(this.matchCorrBgc(item)?.bgc)

            Span(item.time_token + '\n')
              .fontSize(14)
              .fontColor(this.matchCorrBgc(item)?.bgc)

            Span(item.mileage + 'km  ' + (item.trip_time !== 0 ? item.trip_time + ' min' : '未设置出行用时'))
              .fontSize(14)
              .fontColor('#000')
          }
          .textAlign(TextAlign.Start)
          .lineHeight(30)
          .layoutWeight(1)

          Text(item.carbon_emission + ' kg')
            .fontSize(17)
            .fontColor(this.matchCorrBgc(item)?.bgc)
        }
        .padding({ left: 20, right: 10 })
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(100)
        .backgroundColor(this.matchCorrBgc(item)?.bgcCard)
        .border({ width: { bottom: 2 }, color: '#ccc', radius: 15 })
      })

      Column()
        .width('100%')
        .height(80)
    }
    .padding({ left: 20, right: 20 })
    .width('100%')
  }

  @Builder
  timeAppsItemListBuilder() {
    Column({ space: 8 }) {
      Text(this.subHeading)
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#000')
        .width('100%')
        .textAlign(TextAlign.Start)

      ForEach(this.funcList, (item: ApplianceItemDataType, index: number) => {
        Row({ space: 20 }) {
          Image(this.matchCorrBgc(item)?.img)
            .width(40)
            .fillColor(this.matchCorrBgc(item)?.tsc)

          Text() {
            Span(item.appliance + '   ')
              .fontSize(18)
              .fontColor(this.matchCorrBgc(item)?.bgc)

            Span(item.time_token + '\n')
              .fontSize(14)
              .fontColor(this.matchCorrBgc(item)?.bgc)

            Span(item.use_time + 'h  ' + (item.elect_power !== 0 ? item.elect_power + ' W' : '未设置用电功率'))
              .fontSize(14)
              .fontColor('#000')
          }
          .textAlign(TextAlign.Start)
          .lineHeight(30)
          .layoutWeight(1)

          Text(item.carbon_emission + ' kg')
            .fontSize(17)
            .fontColor(this.matchCorrBgc(item)?.bgc)
        }
        .padding({ left: 20, right: 10 })
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(100)
        .backgroundColor(this.matchCorrBgc(item)?.bgcCard)
        .border({ width: { bottom: 2 }, color: '#ccc', radius: 15 })
      })

      Column()
        .width('100%')
        .height(80)
    }
    .padding({ left: 20, right: 20 })
    .width('100%')
  }

  @Builder
  timeFoodItemListBuilder() {
    Column({ space: 8 }) {
      Text(this.subHeading)
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#000')
        .width('100%')
        .textAlign(TextAlign.Start)

      ForEach(this.funcList, (item: FoodItemDataType, index: number) => {
        Row({ space: 20 }) {
          Image(this.matchCorrBgc(item)?.img)
            .width(40)
            .fillColor(this.matchCorrBgc(item)?.tsc)

          Text() {
            Span(item.food + '   ')
              .fontSize(18)
              .fontColor(this.matchCorrBgc(item)?.bgc)

            Span(item.time_token + '\n')
              .fontSize(14)
              .fontColor(this.matchCorrBgc(item)?.bgc)

            Span(item.eat_portion + 'g  ' + (item.eat_time !== 0 ? item.eat_time + ' min' : '未设置食用用时'))
              .fontSize(14)
              .fontColor('#000')
          }
          .textAlign(TextAlign.Start)
          .lineHeight(30)
          .layoutWeight(1)

          Text(item.carbon_emission + ' kg')
            .fontSize(17)
            .fontColor(this.matchCorrBgc(item)?.bgc)
        }
        .padding({ left: 20, right: 10 })
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(100)
        .backgroundColor(this.matchCorrBgc(item)?.bgcCard)
        .border({ width: { bottom: 2 }, color: '#ccc', radius: 15 })
      })

      Column()
        .width('100%')
        .height(80)
    }
    .padding({ left: 20, right: 20 })
    .width('100%')
  }

  build() {
    Column() {
      if (this.funcList.length === 0) {
        // 空状态
        Column({ space: 20 }) {
          Image($r('app.media.icon_leave'))
            .width(60)
            .height(60)
            .fillColor('#37800f')

          if (this.index_page === 1) {
            Text('暂无出行记录')
              .fontSize(18)
              .fontColor('#666666')
          } else if (this.index_page === 2) {
            Text('暂无用电记录')
              .fontSize(18)
              .fontColor('#666666')
          } else if (this.index_page === 3) {
            Text('暂无饮食记录')
              .fontSize(18)
              .fontColor('#666666')
          }

          Text('开始绿色出行，记录你的环保足迹')
            .fontSize(14)
            .fontColor('#999999')
        }
        .height(300)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .width('100%')
      } else {
        if (this.index_page === 1) {
          this.timeTransItemListBuilder()
        } else if (this.index_page === 2) {
          this.timeAppsItemListBuilder()
        } else if (this.index_page === 3) {
          this.timeFoodItemListBuilder()
        }
      }
    }
    .width('100%')
    .padding({ top: 16, bottom: 16 })
  }
}