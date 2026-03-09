import { home_mainPage } from "@ohos/home";
import { Mine_homePage } from "@ohos/mine";
import { carbonCircle_homePage } from "@ohos/carboncircle";
import { tendency_homePage } from "@ohos/tendency";
import TabMenusViewModel from "../ViewModel/TabMenusViewModel";

@Component
export struct quickStart {
  @State currentIndex: number = 0;

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
      Tabs({ barPosition: BarPosition.End }) {
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
      .scrollable(true)
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.currentIndex = index
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