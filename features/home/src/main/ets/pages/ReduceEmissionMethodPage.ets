import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";

@Component
export struct reduceEmissionMethodPage {
  @State pageTitle: ResourceStr = $r('app.string.reduceEmissionMethodPage_title')
  @StorageLink('currLoginAcc') acc: string = ''

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
    reduceEmissionMethodPage()
  }
  .hideTitleBar(true)
  .title('reduceEmissionMethodPage')
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_reduceCarbonEmissionMethod
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}