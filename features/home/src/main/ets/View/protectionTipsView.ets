@Component
export struct protectionTipsView {
  build() {
    Column({ space: 10 }) {
      Text($r('app.string.protectionTips_title'))
        .fontColor(Color.Black)
        .fontSize(18)
        .fontWeight(600)

      Row({ space: 10 }) {
        Row({ space: 30 }) {
          Image($r('app.media.protectionTips_one'))
            .width(40)
            .margin({ left: 15 })

          Column({ space: 15 }) {
            Text('森林保护的重要性')
              .fontColor(Color.Black)
              .fontWeight(600)
              .fontSize(18)

            Text('了解森林对地球生态系统的影响')
              .fontColor('#cccccc')
              .fontWeight(400)
              .fontSize(12)
          }
          .width('60%')
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(VerticalAlign.Center)
        .width('78%')
        .height(100)
        .backgroundColor(Color.White)
        .border({ width: 1, color: '#cccccc'})
        .borderRadius(25)

        Row() {
          Image($r('app.media.protectionTips_two'))
            .width(30)
        }
        .backgroundColor('#37800f')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('18%')
        .borderRadius(15)
        .height(100)
      }
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .height(130)
    .width('100%')
    .padding({ left: 10, right: 10 })
  }
}