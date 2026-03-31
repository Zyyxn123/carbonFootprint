import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import { funcListsCards } from "../Component/FuncListsCards";
import { funcListsCurrAction } from "../Component/FuncListsCurrAction";
import { funcListsSelectedMap } from "../Component/FuncListsSelectedMap";
import HouseAPPVM from "../ViewModel/HouseApplicationViewModel";

@Component
export struct houseApplicationPage {
  @State pageTitle: ResourceStr = $r('app.string.functionLists_garbageIdentification')
  @StorageLink('currLoginAcc') acc: string = ''

  async aboutToAppear(): Promise<void> {
    await HouseAPPVM.getTotalData(this.acc)
  }

  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      List() {
        ListItem() {
          funcListsCards({
            cardsDataList: HouseAPPVM.cardsData,
            popBoxDataList: HouseAPPVM.popBoxData
          })
        }

        ListItem() {
          funcListsSelectedMap({
            index_page: 2,
            funcList: HouseAPPVM.applicationsLists,
            title: HouseAPPVM.title })
        }

        ListItem() {
          funcListsCurrAction({
            index_page: 2,
            funcList: HouseAPPVM.applicationsItemList,
            subHeading: HouseAPPVM.subHeading,
            bgcList: HouseAPPVM.applicationsLists
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
    houseApplicationPage()
  }
  .hideTitleBar(true)
  .title($r('app.string.functionLists_garbageIdentification'))
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_houseApplication
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}