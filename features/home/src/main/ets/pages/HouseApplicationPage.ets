import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import { funcListsCards } from "../Component/FuncListsCards";
import { funcListsSelectedMap } from "../Component/FuncListsSelectedMap";
import houseApplicationViewModel from "../ViewModel/HouseApplicationViewModel";

@Component
export struct houseApplicationPage {
  @State pageTitle: ResourceStr = $r('app.string.functionLists_garbageIdentification')



  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      List() {
        ListItem() {
          funcListsCards({
            cardsDataList: houseApplicationViewModel.cardsData,
            popBoxDataList: houseApplicationViewModel.popBoxData
          })
        }

        ListItem() {
          funcListsSelectedMap({
            index_page: 2,
            funcList: houseApplicationViewModel.applicationsLists,
            title: houseApplicationViewModel.title })
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
    houseApplicationPage()
  }
  .hideTitleBar(true)
  .title($r('app.string.functionLists_garbageIdentification'))
  .onBackPressed(() => {
    (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_houseApplication
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}