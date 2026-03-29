import { AnimationUtils } from '../utils/AnimationUtils'

@Component
export struct searchForView {
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
    Row({ space: 10 }) {
      Text($r('app.string.searchForView_carbonEmission'))
        .fontColor($r('app.color.searchForView_carbonEmission_color'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      Row() {
        Image($r('app.media.search_magnifier'))
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

        TextInput({ placeholder: $r('app.string.searchForView_placeholder'), text: $$this.searchStr })
          .backgroundColor(Color.Transparent)
          .placeholderColor($r('app.color.searchForView_placeholder_color'))
          .width(240)
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
      .padding({ left: 10})
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
    }
    .translate({ x: this.translateX })
    .scale({ x: this.myScale, y: this.myScale })
    .width('100%')
    .padding({ left: 10, right: 10, top: 35 })
    .onAppear(() => {
      this.translateX = 0
    })
  }
}