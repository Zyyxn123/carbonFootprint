import { BasicButtons } from "../View/BasicButtons"
import { CarCircleTitle } from "../View/CarCircleTitle"
import { MsgLists } from "../View/MsgLists"
import { OptionSelect } from "../View/OptionSelect"
import msgListVM from "../ViewModel/MsgListViewModel"

@Component
export struct carbonCircle_homePage {
  async aboutToAppear(): Promise<void> {
    if (msgListVM.first) {
      await msgListVM.getPostListFromServer()
      msgListVM.first = false
    }
  }

  build() {
    Column({ space: 10 }) {
      CarCircleTitle()

      BasicButtons()

      OptionSelect()

      MsgLists()
    }
    .width('100%')
    .height('100%')
  }
}