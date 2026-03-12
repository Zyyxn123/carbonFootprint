import { BuilderNameConstants, RouterModule } from "@ohos/customrouter"
import { auxiliaryInfoView } from "../View/auxiliaryInfoView"
import { carbonLevelView } from "../View/carbonLevelView"
import { functionListsView } from "../View/functionListsView"
import { protectionTipsView } from "../View/protectionTipsView"
import { searchForView } from "../View/searchForView"

@Component
export struct home_mainPage {
  build() {
    Column({ space: 15 }) {
      // ToDo: func of search is unknown
      searchForView()
      carbonLevelView()
      functionListsView()
      protectionTipsView()
      auxiliaryInfoView()
    }
    .width('100%')
    .height('100%')
    .padding({ top: 10 })
  }
}