import functionListsTypeModel from '../Model/functionListsModel'
import functionListsViewModel from '../ViewModel/functionListsViewModel'

@Component
export struct functionListsView {

  @Builder funcListItem(item: functionListsTypeModel, index: number) {
    Column({ space: 10 }) {
      Image(item.image)
        .width(45)

      Text(item.text)
        .fontColor(Color.Black)
        .fontSize(13)
        .fontWeight(600)
    }
  }

  build() {
    Row() {
      ForEach(functionListsViewModel.functionLists,
        (item: functionListsTypeModel, index: number) => {
          this.funcListItem(item, index)
        })
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .width('100%')
    .padding({ left: 10, right: 10 })
  }
}