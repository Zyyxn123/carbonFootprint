import { BuilderNameConstants, buildRouterModel, RouterModule, RouterNameConstants } from '@ohos/customrouter';
import { AdsPage } from './AdsPage';
import { LogOrResPage } from './LogOrResPage';

@Entry
@Component
struct EntryHap {
  @StorageLink('entryHapRouter') entryHapRouter: NavPathStack = new NavPathStack()
  @State firstAds: boolean = true//

  aboutToAppear() {
    if (!this.entryHapRouter) {
      this.entryHapRouter = new NavPathStack()
    }
    RouterModule.createRouter(RouterNameConstants.ENTRY_HAP, this.entryHapRouter)
  }

  @Builder
  routerMap(builderName: string, param: object) {
    if (builderName === 'AdsPage') {
      AdsPage()
    } else if (builderName === 'LogOrResPage') {
      LogOrResPage()
    } else {
      RouterModule.getBuilder(builderName).builder(param)
    }
  }

  build() {
    Navigation(this.entryHapRouter) {
    }
    .title('NavIndex')
    .navDestination(this.routerMap)
    .backgroundColor($r('app.color.launch_ads_background'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onAppear(() => {
      this.entryHapRouter.replacePathByName('AdsPage', null, false)
    })
  }
}