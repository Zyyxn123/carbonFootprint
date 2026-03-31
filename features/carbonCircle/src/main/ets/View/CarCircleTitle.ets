@Component
export struct CarCircleTitle {
  build() {
    Row() {
      Text('碳友圈')
        .fontColor('#000')
        .fontSize(20)
        .fontWeight(600)
    }
    .padding({ top: 35 })
  }
}