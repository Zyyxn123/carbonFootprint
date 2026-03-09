@Component
export struct basicData {
  build() {
    Row() {
      Column({ space: 15 }) {
        Image($r('app.media.avatar_1th'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ left: 25, right: 15 })

        Row() {
          Text('用户姓名')
            .fontSize(20)
            .fontWeight(600)
            .fontColor(Color.Black)

          // Button('关注')
          //   .backgroundColor('#37800f')
          //   .fontColor(Color.Black)
          //   .borderRadius(15)
          //   .fontSize(12)
          //   .fontWeight(500)
          //   .height(30)
        }
        .margin({ left: 25, right: 15 })
      }
      .justifyContent(FlexAlign.Center)


      Column({ space: 10 }) {
        Text('关注 124     粉丝 99')
          .fontSize(15)
          .fontColor(Color.Black)
        Text('贡献 30     积分 1331')
          .fontSize(15)
          .fontColor(Color.Black)
      }
      .alignItems(HorizontalAlign.Start)
      .backgroundColor(Color.White)
      .border({ width: 1, color: '#ffeaeaea', radius: 15 })
      .padding(15)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .height(220)
    .width('100%')
  }
}