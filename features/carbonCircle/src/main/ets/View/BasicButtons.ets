import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"
import { AnimationUtils } from "../Util/AnimationUtils"

@Component
export struct BasicButtons {
  @State searchStr: string = ''
  @State isFocused: boolean = false
  @State isHovered: boolean = false
  @State myScale: number = 1
  @State translateX: number = 100 // 用于从右侧滑入
  @State rotateAngle: number = 0 // 图标旋转角度
  @State rippleScale: number = 0 // 涟漪效果缩放
  @State searchBoxScale: number = 1 // 搜索框缩放
  @State hasAppeared: boolean = false

  build() {
    Row({ space: 15 }) {
      Image($r('app.media.avatar_1th'))
        .width(45)
        .borderRadius(25)

      Row() {
        Image($r('app.media.search_magnifier'))
          .margin({ left: 5 })
          .width(25)
          .fillColor($r('app.color.searchForView_magnifier_color'))
          .rotate({ angle: this.rotateAngle })
          .animation({ duration: 200, curve: Curve.EaseInOut, playMode: PlayMode.Normal })
          .onHover((isHover: boolean) => {
            if (isHover) {
              this.rotateAngle = 15
            } else {
              this.rotateAngle = 0
            }
          })

        TextInput({ placeholder: '搜索', text: $$this.searchStr })
          .backgroundColor(Color.Transparent)
          .placeholderColor($r('app.color.searchForView_placeholder_color'))
          .width(180)
          .onFocus(() => {
            this.isFocused = true
            this.searchBoxScale = 1.05
          })
          .onBlur(() => {
            this.isFocused = false
            this.searchBoxScale = 1
          })
      }
      .scale({ x: this.searchBoxScale, y: this.searchBoxScale })
      .border({
        width: 1,
        color: this.isFocused ? $r('app.color.searchForView_focus_border_color') : $r('app.color.searchForView_border_color'),
        radius: 25
      })
      .shadow({
        radius: this.isFocused ? 10 : 0,
        color: this.isFocused ? $r('app.color.searchForView_shadow_color') : Color.Transparent,
        offsetX: 0,
        offsetY: 2
      })
      .animation(AnimationUtils.hoverScale())
      .onClick(() => {
        // 涟漪效果：临时放大再恢复
        this.searchBoxScale = 1.1
        setTimeout(() => {
          this.searchBoxScale = this.isFocused ? 1.05 : 1
        }, 150)
      })
      .onHover((isHover: boolean) => {
        this.isHovered = isHover
        if (isHover && !this.isFocused) {
          this.searchBoxScale = 1.02
        } else if (!isHover && !this.isFocused) {
          this.searchBoxScale = 1
        }
      })

      Image($r('app.media.carCircle_send'))
        .fillColor('#7fa25e')
        .width(25)
        .onClick(() => {
          buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_carboncircle_msgEditingPage)
        })

      Image($r('app.media.carCircle_emails'))
        .fillColor('#7fa25e')
        .width(30)
    }
    .padding({ left: 10, right: 10})
  }
}