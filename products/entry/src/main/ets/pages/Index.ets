import { BuilderNameConstants, buildRouterModel, RouterModule, RouterNameConstants } from '@ohos/customrouter';
import {
  CarEmiApplianceTable,
  CarEmiFoodTable,
  CarEmiTotalWeeklyTable,
  CarEmiTransTable,
  HealthyNewsPreference,
  HTTPForHealthyNews,
  TendTasksTable
} from '@ohos/utils';
import { LogOrResPage } from './LogOrResPage';
import common from '@ohos.app.ability.common';
import { home_mainPage } from '@ohos/home';
import { tendency_homePage } from '@ohos/tendency';
import { carbonCircle_homePage } from '@ohos/carboncircle';
import { Mine_homePage } from '@ohos/mine';
import TabMenusViewModel from '../ViewModel/TabMenusViewModel';
import TabMenusTYpeModel from '../Model/TabMenusModel';

let date = new Date()

AppStorage.setOrCreate('isLoginState', false)
AppStorage.setOrCreate('CurrentIndex', 0)
AppStorage.setOrCreate('currLoginAcc', '')

@Entry
@Component
struct c {
  @StorageLink('CurrentIndex') currentIndex: number = 0
  @State entryHapRouter: NavPathStack = new NavPathStack()
  @StorageLink('isLoginState') isLogin: boolean = false
  @State hoverIndex: number = -1
  private healthyNewsPre: HealthyNewsPreference = HealthyNewsPreference.getInstance()
  private httpForHN: HTTPForHealthyNews = HTTPForHealthyNews.getInstance()
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext
  private tabCtrl: TabsController = new TabsController()
  private carEmiTransTable: CarEmiTransTable = CarEmiTransTable.getInstance()
  private carEmiApplianceTable: CarEmiApplianceTable = CarEmiApplianceTable.getInstance()
  private carEmiFoodTable: CarEmiFoodTable = CarEmiFoodTable.getInstance()
  private carEmiTotalWeeklyTable: CarEmiTotalWeeklyTable = CarEmiTotalWeeklyTable.getInstance()
  private tendTasksTable: TendTasksTable = TendTasksTable.getInstance()

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
      this.healthyNewsPre.setTodayTime(date.toLocaleDateString())
      this.httpForHN.HTTPFunc()
    }

    setTimeout(() => {
      this.carEmiTransTable.initTable()
      this.carEmiApplianceTable.initTable()
      this.carEmiFoodTable.initTable()
      this.carEmiTotalWeeklyTable.initTable()
      this.tendTasksTable.initTable()
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

  // 自定义导航条Canvas背景绘制
  drawTabBarBackground(ctx: CanvasRenderingContext2D, width: number, height: number) {
    // 清除画布
    ctx.clearRect(0, 0, width, height)

    // 绘制半透明背景（磨砂玻璃效果）
    ctx.fillStyle = 'rgba(255, 255, 255, 0.85)'
    ctx.beginPath()
    ctx.roundRect(0, 0, width, height, 20)
    ctx.fill()

    // 绘制顶部细边框
    ctx.strokeStyle = 'rgba(120, 180, 120, 0.2)'
    ctx.lineWidth = 1
    ctx.beginPath()
    ctx.moveTo(0, 0)
    ctx.lineTo(width, 0)
    ctx.stroke()
  }

  // 绘制选中指示器（绿色渐变圆角矩形）
  drawIndicator(ctx: CanvasRenderingContext2D, x: number, width: number, height: number) {
    const indicatorHeight = 4
    const cornerRadius = 2

    // 绿色渐变
    const gradient = ctx.createLinearGradient(x, 0, x + width, 0)
    gradient.addColorStop(0, '#4CAF50')
    gradient.addColorStop(0.5, '#37800F')
    gradient.addColorStop(1, '#2E7D32')

    ctx.fillStyle = gradient
    ctx.beginPath()
    ctx.roundRect(x, height - indicatorHeight, width, indicatorHeight, cornerRadius)
    ctx.fill()

    // 添加内发光
    ctx.shadowColor = '#4CAF50'
    ctx.shadowBlur = 8
    ctx.shadowOffsetX = 0
    ctx.shadowOffsetY = 0
    ctx.fill()
    ctx.shadowBlur = 0
  }

  // 自定义导航条Builder
  @Builder
  customTabBarBuilder() {
    Stack({ alignContent: Alignment.Top }) {
      // 底层：磨砂玻璃背景（透明效果）
      Column()
        .width('100%')
        .height(90)
        .backgroundColor('rgba(255, 255, 255, 0.75)')
        .backdropBlur(10)
        .borderRadius({ topLeft: 20, topRight: 20 })
        .shadow({ radius: 20, color: 'rgba(0, 0, 0, 0.05)', offsetY: -5 })

      Row() {
        ForEach(TabMenusViewModel.TabsMenu, (item: TabMenusTYpeModel, index: number) => {
          Column() {
            // 图标容器（带悬浮和选中动画）
            Stack({ alignContent: Alignment.Center }) {
              // 背景光环（选中或悬停时显示）
              if (this.currentIndex === index || this.hoverIndex === index) {
                Circle()
                  .width(50)
                  .height(50)
                  .fill(this.currentIndex === index ? 'rgba(76, 175, 80, 0.15)' : 'rgba(120, 180, 120, 0.1)')
                  .animation({ duration: 300, curve: Curve.EaseOut })
              }

              Image(this.currentIndex === index ? item.selectImage : item.image)
                .width(26)
                .height(26)
                .animation({ duration: 200, curve: Curve.EaseOut })
            }
            .width(50)
            .height(50)
            .margin({ bottom: 6 })

            Text(item.text)
              .fontSize(11)
              .fontColor(this.currentIndex === index ? '#37800F' : '#5A5A5A')
              .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
              .opacity(this.currentIndex === index ? 1 : 0.8)
              .animation({ duration: 200, curve: Curve.EaseOut })
          }
          .width('25%')
          .height(80)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            this.currentIndex = index
          })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.hoverIndex = index
            } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
              this.hoverIndex = -1
            }
          })
          .scale({
            x: this.hoverIndex === index ? 1.08 : (this.currentIndex === index ? 1.05 : 1),
            y: this.hoverIndex === index ? 1.08 : (this.currentIndex === index ? 1.05 : 1)
          })
          .animation({ duration: 200, curve: Curve.EaseOut })
        })
      }
      .width('100%')
      .height(80)
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height(90)
    .backgroundColor(Color.Transparent)
  }

  @Builder
  contentBuilder() {
    if (this.currentIndex === 0) {
      home_mainPage()
    }
    else if (this.currentIndex === 1) {
      tendency_homePage()
    }
    else if (this.currentIndex === 2) {
      carbonCircle_homePage()
    }
    else if (this.currentIndex === 3) {
      Mine_homePage()
    }
    else {
      home_mainPage()
    }
  }

  build() {
    if (this.isLogin) {
      Navigation(this.entryHapRouter) {
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            this.contentBuilder()
          }
          .width('100%')
          .height('100%')

          this.customTabBarBuilder()
        }
        .width('100%')
        .height('100%')
      }
      .title('NavIndex')
      .hideTitleBar(true)
      .navDestination(this.routerMap)
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
        LogOrResPage({ isLogin: this.isLogin })
      }
    }
  }
}

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