import { AxisLabelsPosition, PolylineView } from "@abner/polyline"

@Component
export struct carbonLineChart {
  build() {
    Column({ space: 10 }) {
      Row() {
        Row() {
          Text('均值趋势')
            .fontColor($r('app.color.carbonFootprintTitle_color'))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
        }

        if (this.xClickLabel !== undefined && this.yClickData !== undefined) {
          Text(`当前选中：${this.xClickLabel} - ${this.yClickData}`)
            .fontSize(12)
            .fontColor('#ff0000')
            .backgroundColor('#f5f5f5')
            .padding(4)
            .borderRadius(4)
        }

        Row() {
          Text('本周')
            .fontColor($r('app.color.carbonFootprintTitle_color'))
            .fontSize(10)
            .margin({ right: 15 })
          Text('上周')
            .fontColor($r('app.color.carbonFootprintTitle_color'))
            .fontSize(10)
        }
        .padding(6)
        .backgroundColor('#ccf493')
        .borderRadius(15)
        .margin({ right: 6})
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      // 2. 折线图核心组件
      PolylineView({
        xLabels: this.xLabels,
        data: this.yData,
        minY: 0,
        maxY: 5,
        axisLabelsPosition: AxisLabelsPosition.between,
        // 十字光标配置
        onCrossHairData: (hair) => {
          hair.show = true
          hair.color = "#ff0000"
          hair.width = 1
          // 可选：设置十字光标为虚线
          hair.isDottedLine = true
          hair.dash = [5, 5]
        },
        // 点击交点事件（核心修复）
        onClickPointEvent: (bean) => {
          // 1. 获取点击位置的坐标数据
          this.xClickLabel = this.xLabels[bean.position!]
          this.yClickData = this.yData[bean.position!]

          // 2. 手动指定十字光标定位到点击的交点（关键）
          this.selectedCrossHairX = bean.position! // 交点X坐标
          this.selectedCrossHairY = bean.position! // 交点Y坐标

          // 3. 2秒后清空选中状态
          clearTimeout(this.tempPieChartTimeout)
          this.tempPieChartTimeout = setTimeout(() => {
            this.xClickLabel = undefined
            this.yClickData = undefined
            this.selectedCrossHairX = -1 // 隐藏十字光标
            this.selectedCrossHairY = -1
          }, 2000)
        },
        // 折线样式
        onLineData: (line) => {
          line.color = "#d95011"
          line.width = 2
        },
        // 交点样式
        onPointData: (point) => {
          point.show = true
          point.radius = 6
          point.fillColor = "#d95011"
          point.strokeColor = "#ffffff"
          point.width = 2
        },
        // 网格样式
        onGridData: (grid) => {
          grid.isDottedLine = true
          grid.showVerticalLine = false
          grid.color = "#e5e5e5"
        },
        // 刻度样式
        onCoordinateScaleData: (scale) => {
          scale.show = true
          scale.showYLine = false
          scale.showXLine = true
          scale.hideXFirst = true
        }
      })
        .width("100%")
        .height(160)
    }
    .alignItems(HorizontalAlign.Center)
  }

  @State xLabels: string[] = ['1:00', '2:00', '3:00', '4:00', '5:00']
  @State yData: number[] = [1.2, 1.8, 2.6, 3.6, 4.2]
  @State tempPieChartTimeout: number = 100
  // 控制十字光标定位的坐标（关键：手动指定光标位置）
  @State selectedCrossHairX: number = -1
  @State selectedCrossHairY: number = -1
  // 点击后的X轴标签（用于展示）
  @State xClickLabel: string | undefined = undefined
  // 点击后的Y轴数值（用于展示）
  @State yClickData: number | undefined = undefined
}