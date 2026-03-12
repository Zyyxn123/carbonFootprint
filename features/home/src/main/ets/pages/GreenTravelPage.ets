import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import { funcListsCards } from "../Component/FuncListsCards";
import { funcListsCurrAction } from "../Component/FuncListsCurrAction";
import { funcListsSelectedMap } from "../Component/FuncListsSelectedMap";
import GreenTravelViewModel from "../ViewModel/GreenTravelViewModel";

@Component
export struct greenTravelPage {
  @State pageTitle: ResourceStr = $r('app.string.greenTravelPage_title')

  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      List() {
        ListItem() {
          funcListsCards({
            cardsDataList: GreenTravelViewModel.cardsData,
            popBoxDataList: GreenTravelViewModel.popBoxData
          })
        }

        ListItem() {
          funcListsSelectedMap({
            funcList: GreenTravelViewModel.transportLists,
            title: GreenTravelViewModel.title })
        }

        // ListItem() {
        //   funcListsCurrAction()
        // }
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
    greenTravelPage()
  }
  .hideTitleBar(true)
  .title($r('app.string.greenTravelPage_title'))
  .onBackPressed(() => {
    // (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_greenTravel
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}