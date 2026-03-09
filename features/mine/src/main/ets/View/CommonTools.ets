@Component
export struct commonTools {
  build() {
    Column() {
      Text('常用工具')
        .fontColor(Color.Black)
        .fontWeight(600)
        .fontSize(18)
        .margin({ bottom: 15, top: 10, left: 15 })
    }
    .alignItems(HorizontalAlign.Start)
    .width('95%')
    .margin({ left: 10, right: 10 })
    .backgroundColor(Color.White)
    .border({width: 1, color: '#cccccc', radius: 15})
  }
}