import { BuilderNameConstants, buildRouterModel, RouterModule, RouterNameConstants } from '@ohos/customrouter';
import { HealthyNewsPreference, HTTPForHealthyNews } from '@ohos/utils';
import { AdsPage } from './AdsPage';
import { LogOrResPage } from './LogOrResPage';
import { quickStart } from './quickStart';
import common from '@ohos.app.ability.common';

let date = new Date()

@Entry
@Component
struct EntryHap {
  @StorageLink('entryHapRouter') entryHapRouter: NavPathStack = new NavPathStack()
  private healthyNewsPre: HealthyNewsPreference = HealthyNewsPreference.getInstance()
  private httpForHN: HTTPForHealthyNews = HTTPForHealthyNews.getInstance()
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext

  async aboutToAppear() {
    this.healthyNewsPre.getMyPre(this.context)
    if (!this.entryHapRouter) {
      this.entryHapRouter = new NavPathStack()
    }
    RouterModule.createRouter(RouterNameConstants.ENTRY_HAP, this.entryHapRouter)
    AppStorage.setOrCreate('entryHapRouter', this.entryHapRouter)

    if (this.healthyNewsPre.getTodayTime() === date.toLocaleDateString()) {
      if (this.healthyNewsPre.getTodayData_HN()) {
        this.httpForHN.data = this.healthyNewsPre.getTodayData_HN()
      }
    } else {
      this.healthyNewsPre.setTodayTime()
      this.httpForHN.HTTPFunc()
    }
  }

  @Builder
  routerMap(builderName: string, param: object) {
    if (builderName === 'AdsPage') {
      AdsPage()
    } else if (builderName === 'LogOrResPage') {
      LogOrResPage()
    } else if (builderName === 'quickStart') {
      quickStart()
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
    .onAppear(async () => {
      this.entryHapRouter.pushPathByName('LogOrResPage', null, false)
    })
  }
}

// let date = new Date()
// console.log('dateTextOnly ', date)
// console.log('dateTextOnly toString', date.toString())
// console.log('dateTextOnly toDateString', date.toDateString())
// console.log('dateTextOnly toTimeString', date.toTimeString())
// console.log('dateTextOnly toLocaleString', date.toLocaleString())
// console.log('dateTextOnly toLocaleDateString', date.toLocaleDateString()) // 3/12/2026
// console.log('dateTextOnly toLocaleTimeString', date.toLocaleTimeString())
// console.log('dateTextOnly valueOf', date.valueOf())
// console.log('dateTextOnly getTime', date.getTime())
// console.log('dateTextOnly getFullYear', date.getFullYear())
// console.log('dateTextOnly getUTCFullYear', date.getUTCFullYear())
// console.log('dateTextOnly getMonth', date.getMonth())
// console.log('dateTextOnly getDate', date.getDate())