import { LevelProgress } from "../Components/LevelProgress"
import dataSumVM from "../ViewModel/DataSumViewModel"
import { McBarChart, Options } from '@mcui/mccharts'
import { PieChartData, PieChartType, PieChartView } from "@abner/pie"

@Extend(Column)
function ColStyles(height: number, padding: number) {
  .width('48%')
  .backgroundColor('#fff')
  .height(height)
  .border({ width: { bottom: 2 }, color: '#ccc' })
  .borderRadius(15)
  .padding(padding)
  .alignItems(HorizontalAlign.Start)
}

@Component
export struct DataSummary {
  @State currIndex: number = 0
  @State isShow: boolean = false
  @State isShow2: boolean = false
  @StorageLink('currLoginAcc') acc: string = ''
  @State chartData: PieChartData[] = [
    { label: "交通", value: 50, color: "#37800f" },
    { label: "电器", value: 30, color: "#65ff00dd" },
    { label: "饮食", value: 20, color: "#65ffe600" }
  ]

  async aboutToAppear(): Promise<void> {
    await dataSumVM.updateAllData(this.currIndex, this.acc)
    setTimeout(() => {
      this.isShow = true
      this.isShow2 = true
    }, 500)
  }

  build() {
    Column() {
      Row({ space: 5 }) {
        ForEach(dataSumVM.sortList, (item: number, index: number) => {
          Row() {
            Text('近' + item + '天')
              .fontSize(15)
              .fontColor('#000')
              .fontWeight(600)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.currIndex === index ? '#ff4ba512' : '#fff')
          .width('28%')
          .padding(8)
          .borderRadius(25)
          .onClick(async () => {
            this.currIndex = index
            this.isShow = false
            await dataSumVM.updateAllData(this.currIndex, this.acc)
            setTimeout(() => {
              this.isShow = true
            }, 500)
          })
        })
      }
      .padding({ left: 10, right: 10 })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('80%')
      .height(45)
      .borderRadius(22)
      .backgroundColor('#fff')
      .border({ width: { bottom: 2 }, color: '#ccc' })
      .margin({ bottom: 25 })

      Row({ space: 10 }) {
        Column({ space: 5 }) {
          Text('累计总碳排量')
            .fontColor('#757575')
            .fontSize(14)

          if (this.isShow) {
            Text() {
              Span(dataSumVM.totalCarEmi.toString())
                .fontColor('#000')
                .fontSize(24)
              Span(' kg CO₂e')
                .fontColor('#757575')
                .fontSize(15)
            }
          } else {
            LoadingProgress()
              .color('#37800f')
              .width(28)
          }

          Text(`统计周期：近${dataSumVM.sortList[this.currIndex]}天`)
            .fontColor('#757575')
            .fontSize(14)
        }
        .ColStyles(100, 12)

        Column({ space: 5 }) {
          Text('日均碳排量')
            .fontColor('#757575')
            .fontSize(14)

          if (this.isShow) {
            Text() {
              Span(dataSumVM.EmiAverage.toString())
                .fontColor('#000')
                .fontSize(24)
              Span(' kg CO₂e/天')
                .fontColor('#757575')
                .fontSize(15)
            }
          } else {
            LoadingProgress()
              .color('#37800f')
              .width(28)
          }

          Text(dataSumVM.isHigh ? '高于全国人均' : `低于全国人均`)
            .fontColor(dataSumVM.isHigh ? '#D32F2F' : '#2E7D32')
            .fontSize(14)
            .padding({
              left: 6,
              right: 6,
              top: 4,
              bottom: 4
            })
            .backgroundColor(dataSumVM.isHigh ? '#FFE0E0' : '#DCFCE7')
            .borderRadius(15)
        }
        .ColStyles(100, 12)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .margin({ bottom: 10 })

      Row({ space: 10 }) {
        Column({ space: 7 }) {
          Text('AI预估减排潜力')
            .fontColor('#757575')
            .fontSize(14)

          // if (this.isShow) {
          Text() {
            Span(dataSumVM.aiEstimateEmi.toString())
              .fontColor('#2E7D32')
              .fontSize(24)
            Span(' kg CO₂e/月')
              .fontColor('#757575')
              .fontSize(15)
          }

          // } else {
          //   LoadingProgress()
          //     .color('#37800f')
          //     .width(28)
          // }

          Text(`践行方案后可减少`)
            .fontColor('#757575')
            .fontSize(14)
        }
        .ColStyles(150, 15)

        Column({ space: 5 }) {
          Text('低碳等级评定')
            .fontColor('#757575')
            .fontSize(14)
          Row({ space: 10 }) {
            if (this.isShow2) {
              Text(dataSumVM.showLevel.name)
                .fontSize(25)
                .fontColor(dataSumVM.showLevel.color)
                .width(50)
                .height(60)

              LevelProgress({ data: dataSumVM.showLevel })
            } else {
              LoadingProgress()
                .color('#37800f')
                .width(28)
            }
          }
          .width('100%')
          .height(80)
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)

          Text(`当前碳排水平授予`)
            .fontColor('#757575')
            .fontSize(14)
        }
        .ColStyles(150, 15)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .margin({ bottom: 15 })

      Column({ space: 10 }) {
        Row({ space: 20 }) {
          Text('全场景碳排占比')
            .fontSize(20)
            .fontColor('#000')
            .width(25)
            .fontWeight(600)

          if (this.isShow) {
            PieChartView({
              chartData: dataSumVM.chartData,
              textColor: '#000',
              radius: 80
            })
              .height(200)
              .width(200)
          } else {
            Row() {
              LoadingProgress()
                .color('#37800f')
                .width(28)
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .width(200)
            .height(200)
          }
        }
        .height(200)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          ForEach(this.chartData, (item: PieChartData) => {
            Row() {
              Rect()
                .width(30)
                .height(20)
                .fill("" + item.color)
                .border({ width: 1, color: '#ccc' })
              Text(item.label)
                .margin({ left: 5 })
                .fontColor('#000')
            }.margin({ right: 5 })
          })
        }
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .backgroundColor(Color.White)
      .height(250)
      .borderRadius(25)
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [['#DCFCE7', 0.2], ['#edffdd', 0.6], ['#fff', 0.8]]
      })
      .border({ width: { top: 1, left: 1, right: 1, bottom: 2 }, color: '#ccc' })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .padding({ left: 10, right: 10 })
  }
}