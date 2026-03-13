import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import EnvironmentalTipsViewModel from "../ViewModel/ProtectionTipsViewModel";
import { JSON } from "@kit.ArkTS";

@Component
export struct environmentalTipsPage {
  @State pageTitle: ResourceStr = $r('app.string.functionLists_environmentalEncyclopedia')

  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

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
    environmentalTipsPage()
  }
  .hideTitleBar(true)
  .title('environmentalTipsPage')
  .onBackPressed(() => {
    (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_environmentalTips
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}