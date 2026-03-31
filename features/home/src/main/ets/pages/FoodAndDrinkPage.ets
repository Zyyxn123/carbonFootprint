import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import { funcListsCards } from "../Component/FuncListsCards";
import { funcListsCurrAction } from "../Component/FuncListsCurrAction";
import { funcListsSelectedMap } from "../Component/FuncListsSelectedMap";
import FoodDVM from "../ViewModel/FoodAndDrinkViewModel";

@Component
export struct foodAndDrinkPage {
  @State pageTitle: ResourceStr = $r('app.string.functionLists_recycling')
  @StorageLink('currLoginAcc') acc: string = ''

  async aboutToAppear(): Promise<void> {
    await FoodDVM.getTotalData(this.acc)
  }
  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      List() {
        ListItem() {
          funcListsCards({
            cardsDataList: FoodDVM.cardsData,
            popBoxDataList: FoodDVM.popBoxData
          })
        }

        ListItem() {
          funcListsSelectedMap({
            index_page: 3,
            funcList: FoodDVM.foodAndDrinkLists,
            title: FoodDVM.title })
        }

        ListItem() {
          funcListsCurrAction({
            index_page: 3,
            funcList: FoodDVM.foodItemList,
            subHeading: FoodDVM.subHeading,
            bgcList: FoodDVM.foodAndDrinkLists
          })
        }
      }
      .width('100%')
      .height('100%')
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
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_foodAndDrink
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}