import { backgroundAndIpView } from "../View/BackgroundAndIpView"
import { logOrResView } from "../View/LogOrResView"

@Component
export struct LogOrResPage {
  @Link isLogin: boolean
  @StorageLink('entryHapRouter') entryHapRouter: NavPathStack = new NavPathStack()
  @State showLogin: boolean = false
  @State loginViewTranslateY: number = 100
  @State startY: number = 0
  @State isDragging: boolean = false
  @State startShowLogin: boolean = false
  @State startTranslateY: number = 100

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom}) {
        backgroundAndIpView()

        logOrResView({ isLogin: this.isLogin})
          .translate({ y: `${this.loginViewTranslateY}%` })
          .opacity(this.showLogin ? 1 : 0.7)
          .animation({ duration: 300, curve: Curve.EaseOut })
      }
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .onTouch((event: TouchEvent) => {
        this.handleTouchEvent(event)
      })
    }
    .hideTitleBar(true)
    .onBackPressed(() => true)
  }

  handleTouchEvent(event: TouchEvent) {
    switch (event.type) {
      case TouchType.Down:
        this.startY = event.touches[0].y
        this.startShowLogin = this.showLogin
        this.startTranslateY = this.loginViewTranslateY
        this.isDragging = true
        break
      case TouchType.Move:
        if (this.isDragging) {
          const currentY = event.touches[0].y
          const deltaY = this.startY - currentY // 向上滑动为正，向下滑动为负
          const sensitivity = 10 // 灵敏度因子

          // 向上滑动 - 显示登录页
          if (deltaY > 0 && this.loginViewTranslateY > 0) {
            const newTranslateY = Math.max(0, this.loginViewTranslateY - deltaY / sensitivity)
            this.loginViewTranslateY = newTranslateY
            if (newTranslateY < 30) {
              this.showLogin = true
            }
          }
          // 向下滑动 - 隐藏登录页
          else if (deltaY < 0 && this.loginViewTranslateY < 100) {
            const newTranslateY = Math.min(100, this.loginViewTranslateY - deltaY / sensitivity)
            this.loginViewTranslateY = newTranslateY
            if (newTranslateY > 70) {
              this.showLogin = false
            }
          }
        }
        break
      case TouchType.Up:
        this.isDragging = false

        // 根据最终位置决定动画
        const finalTranslateY = this.loginViewTranslateY

        if (finalTranslateY < 30) {
          // 滑动到顶部 - 显示登录页
          animateTo({
            duration: 300,
            curve: Curve.EaseOut
          }, () => {
            this.loginViewTranslateY = 0
            this.showLogin = true
          })
        } else if (finalTranslateY > 70) {
          // 滑动到底部 - 隐藏登录页，显示完整动画页
          animateTo({
            duration: 300,
            curve: Curve.EaseOut
          }, () => {
            this.loginViewTranslateY = 100
            this.showLogin = false
          })
        } else {
          // 中间位置 - 回弹到最近状态
          if (this.startShowLogin) {
            // 之前显示登录页，回弹到顶部
            animateTo({
              duration: 300,
              curve: Curve.EaseOut
            }, () => {
              this.loginViewTranslateY = 0
              this.showLogin = true
            })
          } else {
            // 之前隐藏登录页，回弹到底部
            animateTo({
              duration: 300,
              curve: Curve.EaseOut
            }, () => {
              this.loginViewTranslateY = 100
              this.showLogin = false
            })
          }
        }
        break
    }
  }
}