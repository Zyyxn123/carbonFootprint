import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { backButton } from "../Component/BackButton"
import { WebNewValType } from "../Type/WebNewValType"
import { webview } from "@kit.ArkWeb"

@Component
struct webNewsPage {
  @State pageTitle: ResourceStr = '近日新闻'
  @Prop val: object
  private webviewController: WebviewController = new webview.WebviewController()

  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      Web({
        src: (JSON.parse(JSON.stringify(this.val)) as WebNewValType).url,
        controller: this.webviewController,
        renderMode: RenderMode.ASYNC_RENDER
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor('#ffffff')
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    webNewsPage({ val: value })
  }
  .hideTitleBar(true)
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_webNews
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}