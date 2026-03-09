@Component
export struct faceCards {
  build() {
    Row({ space: 10 }) {
      Row({ space: 10 }) {
        Image($r('app.media.mine_order'))
          .width(50)
          .margin({ left: 10 })

        Text('回收订单')
          .fontColor(Color.Black)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
      }
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width('48%')
      .height(80)
      .border({ width: 1, color: '#bfbfbf', radius: 15 })

      Row({ space: 10 }) {
        Image($r('app.media.mine_advance'))
          .width(40)
          .margin({ left: 10 })

        Text('回收预约')
          .fontColor(Color.Black)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width('48%')
      .backgroundColor(Color.White)
      .height(80)
      .border({ width: 1, color: '#bfbfbf', radius: 15 })
    }
    .margin({ top: 10, left: 10, right: 10 })
  }
}