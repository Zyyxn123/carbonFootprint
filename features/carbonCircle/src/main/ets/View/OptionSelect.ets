import msgListVM from "../ViewModel/MsgListViewModel"

@Component
export struct OptionSelect {
  @State offsetX: number = 57
  build() {
    Column({ space: 5 }) {
      Row() {
        Text('广场')
          .fontColor('#000')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .onClick(async () => {
            this.offsetX = 57
            await msgListVM.getPostListFromServer()
          })
          .onAreaChange((oldValue: Area, newValue: Area) => {
            const offsetX = oldValue.globalPosition.x
            const offsetY = oldValue.globalPosition.y
            console.log('OptionSelect1: ' + offsetX, offsetY)
          })
        Text('关注')
          .fontColor('#000')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            this.offsetX = 149
          })
          .onAreaChange((oldValue: Area, newValue: Area) => {
            const offsetX = oldValue.globalPosition.x
            const offsetY = oldValue.globalPosition.y
            console.log('OptionSelect2: ' + offsetX, offsetY)
          })
        Text('好友')
          .fontColor('#000')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            this.offsetX = 242
          })
          .onAreaChange((oldValue: Area, newValue: Area) => {
            const offsetX = oldValue.globalPosition.x
            const offsetY = oldValue.globalPosition.y
            console.log('OptionSelect3: ' + offsetX, offsetY)
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceEvenly)


      Divider()
        .width(35)
        .strokeWidth(5)
        .borderRadius(10)
        .height(5)
        .color('#37800f')
        .vertical(false)
        .position({ x: this.offsetX, y: 35 })
        .animation({ duration: 500 })
    }
    .padding({ left: 20, right: 20 })
    .width('100%')
    .height(40)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}