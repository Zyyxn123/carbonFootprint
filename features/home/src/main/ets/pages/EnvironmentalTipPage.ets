import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";

@Component
export struct environmentalTipPage {
  @State pageTitle: ResourceStr = $r('app.string.protectionTips_title')

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
    environmentalTipPage()
  }
  .hideTitleBar(true)
  .title('environmentalTipPage')
  .onBackPressed(() => {
    (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_environmentalTip
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}