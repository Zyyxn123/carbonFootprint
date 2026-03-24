@Component
export struct reduceEmiTarget {
  build() {
    Column({ space: 10 }) {
      Row() {
        Text('本周减排目标')
          .fontSize(15)
          .fontColor('#000')

        Text() {
          Span('3.2kg')

          Span(' / ')

          Span('5kg')
        }
        .fontSize(16)
        .fontColor('#37800f')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(20)

      Progress({ value: 76, total: 100, type: ProgressType.Linear })
        .width('100%')
        .backgroundColor('#ccc')
        .color('#37800f')
        .style({ strokeWidth: 20 })
        .border({ width: 2, color: '#ccc', radius: 15 })

      Text() {
        Span('距离目标还需减排 ')

        Span('1.8kg')
      }
      .fontSize(14)
      .fontColor('#ccc')
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height(100)
    .backgroundColor('#fff')
    .border({ width: { bottom: 1, right: 1 }, color: '#ccc', radius: 15 })
    .padding(10)
  }
}