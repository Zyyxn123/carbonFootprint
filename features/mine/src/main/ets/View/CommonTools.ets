import { commonToolTypeModel } from "../Model/CommonToolModel"
import CommonToolViewModel from "../ViewModel/CommonToolViewModel"

@Component
export struct commonTools {
  @Builder
  toolsItemBuilder(item: commonToolTypeModel, index: number) {
    Row({ space: 15 }) {
      Image(item.img)
        .width(25)
        .fillColor(Color.Black)
        .margin({ bottom: 10 })

      Row() {
        Text(item.content)
          .fontColor(item.lightModeColor)
          .fontSize(14)

        Text('as')
          .fontColor(Color.Black)
          .fontSize(12)
          .margin({ right: 10 })
      }
      .width('88%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ right: 8, bottom: 15 })
      .border({ width: { bottom: 1 }, color: '#ffececec' })
    }
    .margin({ bottom: 15, top: 10, left: 15 })
  }

  build() {
    Column() {
      Text($r('app.string.mine_tools_title'))
        .fontColor(Color.Black)
        .fontWeight(600)
        .fontSize(18)
        .margin({ bottom: 15, top: 10, left: 15 })

      ForEach(CommonToolViewModel.toolsList,
        (item: commonToolTypeModel, index: number) => {
          this.toolsItemBuilder(item, index)
        })
    }
    .alignItems(HorizontalAlign.Start)
    .width('95%')
    .margin({ left: 10, right: 10 })
    .backgroundColor(Color.White)
    .border({ width: 1, color: '#cccccc', radius: 15 })
  }
}