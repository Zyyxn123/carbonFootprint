import { home_mainPage } from "@ohos/home";
import { Mine_homePage } from "@ohos/mine";
import { carbonCircle_homePage } from "@ohos/carboncircle";
import { tendency_homePage } from "@ohos/tendency";
import TabMenusViewModel from "../ViewModel/TabMenusViewModel";

AppStorage.setOrCreate('CurrentIndex', 0)

@Component
export struct quickStart {
  @StorageLink('CurrentIndex') currentIndex: number = 0
  tabCtrl: TabsController = new TabsController()

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
    NavDestination() {
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
      .onAppear(() => {
        this.tabCtrl.preloadItems([0, 1, 2, 3])
        this.tabCtrl.changeIndex(AppStorage.get('CurrentIndex') as number)
      })
    }
    .hideTitleBar(true)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .linearGradient({
      direction: GradientDirection.Bottom,
      repeating: false,
      colors: [[$r('app.color.page_background_green'), 0.4],
        [$r('app.color.page_background_white'), 0.8]]
    })
    .onBackPressed(() => true)
  }
}

// 碳友圈：关联所有账户，发的评论可以被所有人看见，（点赞，评论留言）