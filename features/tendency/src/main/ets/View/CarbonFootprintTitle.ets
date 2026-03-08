@Component
export struct carbonFootprintTitle {
  build() {
    Row() {
      Text($r('app.string.carbonFootprintTitle'))
        .fontColor($r('app.color.carbonFootprintTitle_color'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
  }
}