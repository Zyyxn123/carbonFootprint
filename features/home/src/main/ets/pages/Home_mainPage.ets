import { BuilderNameConstants, RouterModule } from "@ohos/customrouter"
import { auxiliaryInfoView } from "../View/auxiliaryInfoView"
import { carbonLevelView } from "../View/carbonLevelView"
import { functionListsView } from "../View/functionListsView"
import { protectionTipsView } from "../View/protectionTipsView"
import { searchForView } from "../View/searchForView"

@Component
export struct home_mainPage {
  // 浮动元素动画状态
  @State floatOffset1: number = 0
  @State floatOffset2: number = 0
  @State floatOffset3: number = 0
  @State floatOpacity: number = 0
  // 光晕动画状态
  @State glowOpacity: number = 0
  @State glowScale: number = 0.8

  // 定时器ID
  private floatTimer1: number = 0
  private floatTimer2: number = 0
  private floatTimer3: number = 0

  aboutToAppear() {
    // 初始化浮动动画
    this.startFloatingAnimation()

    // 浮动元素淡入
    setTimeout(() => {
      animateTo({
        duration: 800,
        curve: Curve.EaseOut
      }, () => {
        this.floatOpacity = 0.15
      })
    }, 300)

    // 光晕脉动动画
    setTimeout(() => {
      animateTo({
        duration: 3000,
        curve: Curve.EaseInOut,
        iterations: -1, // 无限循环
        playMode: PlayMode.Alternate
      }, () => {
        this.glowOpacity = 0.08
        this.glowScale = 1.2
      })
    }, 1000)
  }

  // 浮动动画
  startFloatingAnimation() {
    // 元素1浮动 - 左上角
    this.floatTimer1 = setInterval(() => {
      animateTo({
        duration: 4000,
        curve: Curve.EaseInOut
      }, () => {
        this.floatOffset1 = Math.random() * 40 - 20
      })
    }, 4000)

    // 元素2浮动 - 右上角
    this.floatTimer2 = setInterval(() => {
      animateTo({
        duration: 3500,
        curve: Curve.EaseInOut
      }, () => {
        this.floatOffset2 = Math.random() * 30 - 15
      })
    }, 3500)

    // 元素3浮动 - 左下角
    this.floatTimer3 = setInterval(() => {
      animateTo({
        duration: 4500,
        curve: Curve.EaseInOut
      }, () => {
        this.floatOffset3 = Math.random() * 35 - 17.5
      })
    }, 4500)
  }

  aboutToDisappear() {
    // 清理定时器
    if (this.floatTimer1) {
      clearInterval(this.floatTimer1)
    }
    if (this.floatTimer2) {
      clearInterval(this.floatTimer2)
    }
    if (this.floatTimer3) {
      clearInterval(this.floatTimer3)
    }
  }

  build() {
    Stack() {
      // 背景光晕 - 中心脉动效果
      Circle()
        .width(300)
        .height(300)
        .fill('#FFFFFF')
        .opacity(this.glowOpacity)
        .scale({ x: this.glowScale, y: this.glowScale })
        .position({ x: '50%', y: '30%' })
        .translate({ x: '-50%', y: '-50%' })
        .shadow({
          radius: 100,
          color: '#4CAF50'
        })

      // 浮动元素1 - 左上角
      Circle()
        .width(120)
        .height(120)
        .fill('#FFFFFF10')
        .position({ x: '10%', y: '15%' })
        .translate({ x: this.floatOffset1, y: this.floatOffset1 * 0.5 })
        .opacity(this.floatOpacity)
        .shadow({ radius: 20, color: '#FFFFFF15' })

      // 浮动元素2 - 右上角
      Circle()
        .width(80)
        .height(80)
        .fill('#FFFFFF15')
        .position({ x: '85%', y: '20%' })
        .translate({ x: this.floatOffset2, y: -this.floatOffset2 * 0.3 })
        .opacity(this.floatOpacity)
        .shadow({ radius: 15, color: '#FFFFFF10' })

      // 浮动元素3 - 左下角
      Circle()
        .width(100)
        .height(100)
        .fill('#FFFFFF08')
        .position({ x: '15%', y: '75%' })
        .translate({ x: this.floatOffset3 * 0.7, y: this.floatOffset3 })
        .opacity(this.floatOpacity)
        .shadow({ radius: 25, color: '#FFFFFF12' })

      // 主内容
      Column({ space: 15 }) {
        searchForView()
        carbonLevelView()
        functionListsView()
        protectionTipsView()
        auxiliaryInfoView()
      }
      .width('100%')
      .height('100%')
      .padding({ top: 10 })
    }
    .backgroundColor('#E8F5E9')
    .linearGradient({
      direction: GradientDirection.Bottom,
      repeating: false,
      colors: [['#E8F5E9', 0],
        ['#4CAF50', 1]]
    })
    .width('100%')
    .height('100%')
  }
}