import { BasicButtons } from "../View/BasicButtons"
import { CarCircleTitle } from "../View/CarCircleTitle"
import { MsgLists } from "../View/MsgLists"
import { OptionSelect } from "../View/OptionSelect"

@Component
export struct carbonCircle_homePage {
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