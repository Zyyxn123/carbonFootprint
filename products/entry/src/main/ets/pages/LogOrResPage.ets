import { backgroundAndIpView } from "../View/BackgroundAndIpView"
import { logOrResView } from "../View/LogOrResView"

@Component
export struct LogOrResPage {
  @Link isLogin: boolean
  @StorageLink('entryHapRouter') entryHapRouter: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom}) {
        backgroundAndIpView()

        logOrResView({ isLogin: this.isLogin})
      }
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .onBackPressed(() => true)
  }
}