@Component
export struct backgroundAndIpView {
  build() {
    Column() {
      Row() {
        Image($r('app.media.ip_word'))
          .width(120)

        Image($r('app.media.ip'))
          .width(220)
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