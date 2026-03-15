import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import { webview } from "@kit.ArkWeb";

@Component
export struct environmentalTipPage {
  @State pageTitle: ResourceStr = $r('app.string.protectionTips_title')
  @Prop val: object
  private webviewController: WebviewController = new webview.WebviewController()

  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      Web({
        src: (JSON.parse(JSON.stringify(this.val)) as type).uri,
        controller: this.webviewController,
        renderMode: RenderMode.ASYNC_RENDER // 设置渲染模式
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor('#ffffff')
    // .linearGradient({
    //   direction: GradientDirection.Bottom,
    //   repeating: false,
    //   colors: [['#e7fdff', 0],
    //     ['#edffdd', 1]]
    // })
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    environmentalTipPage({ val: value})
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

interface type {
  uri: string
}