@Component
export struct auxiliaryInfoView {
  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.verticalBar'))
          .width(30)
          .fillColor($r('app.color.auxiliaryInfo_verticalBar'))

        Text($r('app.string.auxiliaryInfo_title'))
          .fontColor(Color.Black)
          .fontSize(18)
          .fontWeight(600)
      }

      Row({ space: 10 }) {
        Image($r('app.media.detailedAttention'))
          .width(30)
          .fillColor("#37800F")
          .margin({ left: 5 })

        Column({ space: 10 }) {
          Text('查看详细碳排')
            .fontColor(Color.Black)
            .fontWeight(600)
            .fontSize(16)

          Text('基于用户采集行为数据，按排放因子公式计算')
            .fontColor('#cccccc')
            .fontWeight(500)
            .fontSize(12)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Image($r('app.media.onwards'))
          .width(20)
          .fillColor("#37800F")
          .margin({ right: 6 })
      }
      .height(65)
      .width('100%')
      .borderRadius(25)
      .border({ width: { left: 2, bottom: 1 }, color: "#37800F" })
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [["#ccf493", 0.2], ['#ffffff', 0.7]]
      })
      .justifyContent(FlexAlign.SpaceBetween)

      Row({ space: 10 }) {
        Image($r('app.media.levelDecode'))
          .width(20)
          .fillColor("#37800F")
          .margin({ left: 11, right: 5 })

        Column({ space: 10 }) {
          Text('碳排等级解读')
            .fontColor(Color.Black)
            .fontWeight(600)
            .fontSize(16)

          Text('个人碳排等级 + 风险标签')
            .fontColor('#cccccc')
            .fontWeight(500)
            .fontSize(12)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Image($r('app.media.onwards'))
          .width(20)
          .fillColor("#37800F")
          .margin({ right: 6 })
      }
      .height(65)
      .width('100%')
      .borderRadius(25)
      .border({ width: { left: 2, bottom: 1 }, color: "#37800F" })
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [["#ccf493", 0.2], ['#ffffff', 0.7]]
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .padding({ left: 10, right: 10 })
    .margin({ top: 8 })
  }
}