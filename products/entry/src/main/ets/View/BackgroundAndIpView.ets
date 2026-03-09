@Component
export struct backgroundAndIpView {
  build() {
    Column() {
      Row() {
        Image($r('app.media.img_1'))
          .width(120)
          .fillColor(Color.Blue)

        Image($r('app.media.ip_new'))
          .width(200)
      }
      .width('100%')
      .margin('10%')
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .backgroundColor($r('app.color.logOrRes_background'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}