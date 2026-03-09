@Component
export struct reduceCarbonEmission {
  build() {
    Column({ space: 5 }) {
      Row() {
        Text($r('app.string.reduceEmission_title'))
          .fontColor($r('app.color.carbonFootprintTitle_color'))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .margin({ left: 6 })

        Text() {
          Span('今日减排 ')
            .fontSize(14)
            .fontColor(Color.Black)
          Span('64g')
            .fontSize(22)
            .fontColor('#7fa25e')
        }
        .textAlign(TextAlign.End)
        .margin({ right: 10 })

        Row({ space: 4 }) {
          Text('详细')
            .fontSize(14)
            .fontColor('#808080')
          Image($r('app.media.onwards'))
            .width(18)
            .margin({ right: 6 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      ForEach(Array.from([1, 2, 3]),
        (item: string, index: number) => {
          Row() {
            Image($r('app.media.reduceEmission_water'))
              .width(35)
              .margin({ left: 20, right: 20 })
            Text('随手关水一次')
              .fontColor('#000000')
              .fontSize(16)
              .fontWeight(500)
              .layoutWeight(1)

            Text('-18g')
              .fontColor('#000000')
              .fontSize(14)
              .margin({ right: 20 })
          }
          .width('100%')
          .height(55)
          .borderRadius(20)
          .border({ width: 1, color: '#7fa25e' })
          .alignItems(VerticalAlign.Center)
        })
    }
  }
}