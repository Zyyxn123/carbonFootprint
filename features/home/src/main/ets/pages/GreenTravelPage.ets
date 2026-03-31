import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import { funcListsCards } from "../Component/FuncListsCards";
import { funcListsCurrAction } from "../Component/FuncListsCurrAction";
import { funcListsSelectedMap } from "../Component/FuncListsSelectedMap";
import GreenTVM from "../ViewModel/GreenTravelViewModel";

@Component
export struct greenTravelPage {
  @State pageTitle: ResourceStr = $r('app.string.greenTravelPage_title')
  @StorageLink('currLoginAcc') acc: string = ''

  async aboutToAppear(): Promise<void> {
    await GreenTVM.getTotalData(this.acc)
  }

  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      List() {
        ListItem() {
          funcListsCards({
            cardsDataList: GreenTVM.cardsData,
            popBoxDataList: GreenTVM.popBoxData
          })
        }

        ListItem() {
          funcListsSelectedMap({
            index_page: 1,
            funcList: GreenTVM.transportLists,
            title: GreenTVM.title
          })
        }

        ListItem() {
          funcListsCurrAction({
            index_page: 1,
            funcList: GreenTVM.transportItemList,
            subHeading: GreenTVM.subHeading,
            bgcList: GreenTVM.transportLists
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
    greenTravelPage()
  }
  .hideTitleBar(true)
  .title($r('app.string.greenTravelPage_title'))
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_greenTravel
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}