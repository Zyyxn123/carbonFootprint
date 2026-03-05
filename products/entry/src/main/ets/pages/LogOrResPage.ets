import { backgroundAndIpView } from "../View/backgroundAndIpView"
import { logOrResView } from "../View/logOrResView"

@Component
export struct LogOrResPage {
  @StorageLink('entryHapRouter') entryHapRouter: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom}) {
        backgroundAndIpView()

        logOrResView()
      }
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .onBackPressed(() => true)
  }
}