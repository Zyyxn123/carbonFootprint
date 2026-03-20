import { BuilderNameConstants, buildRouterModel, RouterModule, RouterNameConstants } from '@ohos/customrouter';
import { CarEmiTransTable, HealthyNewsPreference, HTTPForHealthyNews } from '@ohos/utils';
import { AdsPage } from './AdsPage';
import { LogOrResPage } from './LogOrResPage';
import { quickStart } from './quickStart';
import common from '@ohos.app.ability.common';
import { home_mainPage } from '@ohos/home';
import { tendency_homePage } from '@ohos/tendency';
import { carbonCircle_homePage } from '@ohos/carboncircle';
import { Mine_homePage } from '@ohos/mine';
import TabMenusViewModel from '../ViewModel/TabMenusViewModel';

let date = new Date()

AppStorage.setOrCreate('isLoginState', false)
AppStorage.setOrCreate('CurrentIndex', 0)
AppStorage.setOrCreate('currLoginAcc', '')

@Entry
@Component
struct EntryHap {
  @StorageLink('CurrentIndex') currentIndex: number = 0
  @State entryHapRouter: NavPathStack = new NavPathStack()
  @StorageLink('isLoginState') isLogin: boolean = false
  private healthyNewsPre: HealthyNewsPreference = HealthyNewsPreference.getInstance()
  private httpForHN: HTTPForHealthyNews = HTTPForHealthyNews.getInstance()
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext
  private tabCtrl: TabsController = new TabsController()
  private carEmiTransTable: CarEmiTransTable = CarEmiTransTable.getInstance()

  async aboutToAppear() {
    this.healthyNewsPre.getMyPre(this.context)
    if (!this.entryHapRouter) {
      this.entryHapRouter = new NavPathStack()
    }
    RouterModule.createRouter(RouterNameConstants.ENTRY_HAP, this.entryHapRouter)

    if (this.healthyNewsPre.getTodayTime() === date.toLocaleDateString()) {
      if (this.healthyNewsPre.getTodayData_HN()) {
        this.httpForHN.data = this.healthyNewsPre.getTodayData_HN()
      }
    } else {
      this.healthyNewsPre.setTodayTime()
      this.httpForHN.HTTPFunc()
    }

    setTimeout(() => {
      this.carEmiTransTable.initTable()
    }, 500)
  }

  @Builder
  routerMap(builderName: string, param: object) {
      RouterModule.getBuilder(builderName).builder(param)
  }

  @Builder
  tabBarType(index: number) {
    Column() {
      Image(this.currentIndex === index ? TabMenusViewModel.TabsMenu[index].selectImage :
        TabMenusViewModel.TabsMenu[index].image)
        .width(25)
        .margin({ bottom: 5, top: 6 })

      Text(TabMenusViewModel.TabsMenu[index].text)
        .fontSize(15)
        .fontColor(this.currentIndex === index ? $r('app.color.tabBar_fontColor_selected') :
          $r('app.color.tabBar_fontColor'))
    }
  }

  build() {
    if (this.isLogin) {
      Navigation(this.entryHapRouter) {
        Column() {
          Tabs({ barPosition: BarPosition.End, controller: this.tabCtrl }) {
            TabContent() {
              home_mainPage()
            }
            .tabBar(this.tabBarType(0))
            .border({ width: { bottom: 1 }, color: $r('app.color.tabBar_border') })

            TabContent() {
              tendency_homePage()
            }
            .tabBar(this.tabBarType(1))
            .border({ width: { bottom: 1 }, color: $r('app.color.tabBar_border') })

            TabContent() {
              carbonCircle_homePage()
            }
            .tabBar(this.tabBarType(2))
            .border({ width: { bottom: 1 }, color: $r('app.color.tabBar_border') })

            TabContent() {
              Mine_homePage()
            }
            .tabBar(this.tabBarType(3))
            .border({ width: { bottom: 1 }, color: $r('app.color.tabBar_border') })
          }
          .scrollable(false)
          .barMode(BarMode.Fixed)
          .onChange((index: number) => {
            this.currentIndex = index
          })
        }
      }
      .title('NavIndex')
      .hideTitleBar(true)
      .navDestination(this.routerMap)
      .backgroundColor($r('app.color.launch_ads_background'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .linearGradient({
        direction: GradientDirection.Bottom,
        repeating: false,
        colors: [[$r('app.color.page_background_green'), 0.4],
          [$r('app.color.page_background_white'), 0.8]]
      })
      .width('100%')
      .height('100%')
    } else {
      Column() {
        LogOrResPage({ isLogin: this.isLogin})
      }
    }
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