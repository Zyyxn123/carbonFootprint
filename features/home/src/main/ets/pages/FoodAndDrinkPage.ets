import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import { funcListsCards } from "../Component/FuncListsCards";
import { funcListsSelectedMap } from "../Component/FuncListsSelectedMap";
import foodAndDrinkViewModel from "../ViewModel/FoodAndDrinkViewModel";

@Component
export struct foodAndDrinkPage {
  @State pageTitle: ResourceStr = $r('app.string.functionLists_recycling')

  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      List() {
        ListItem() {
          funcListsCards({
            cardsDataList: foodAndDrinkViewModel.cardsData,
            popBoxDataList: foodAndDrinkViewModel.popBoxData
          })
        }

        ListItem() {
          funcListsSelectedMap({
            funcList: foodAndDrinkViewModel.foodAndDrinkLists,
            title: foodAndDrinkViewModel.title })
        }

      //   ListItem() {
      //     funcListsCurrAction()
      //   }
      }
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor('#edffdd')
    .linearGradient({
      direction: GradientDirection.Bottom,
      repeating: false,
      colors: [['#e7fdff', 0],
        ['#edffdd', 1]]
    })
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    foodAndDrinkPage()
  }
  .hideTitleBar(true)
  .title($r('app.string.functionLists_recycling'))
  .onBackPressed(() => {
    // (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_foodAndDrink
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}