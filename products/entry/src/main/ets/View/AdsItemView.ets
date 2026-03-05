import AdsTypeModel from '../Model/AdsModel'

@Component
export struct AdsItemView {
  @Prop item: AdsTypeModel
  @Prop index: number
  @StorageLink('entryHapRouter') entryHapRouter: NavPathStack = new NavPathStack()

  build() {
    Column() {
      Image(this.item.image)
        .width('100%')
        .margin({ top: '20%'})

      Column() {
        Text(this.item.word)
          .fontSize(30)
          .fontColor($r('app.color.launch_ads_bottomWord'))
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: '15%' })

        if (this.index === 2) {
          Button(this.item.buttonWord)
            .width('45%')
            .height('5%')
            .backgroundColor($r('app.color.ads_second_button_background'))
            .fontColor($r('app.color.ads_second_buttonWord_background'))
            .onClick(() => {
              this.entryHapRouter.replacePathByName('LogOrResPage', null, false)
            })
        }
      }
      .margin({ bottom: this.index === 2 ? '20%' : '30%' })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .linearGradient({
      angle: 0,
      direction: GradientDirection.Bottom,
      colors: [[$r('app.color.launchPage_background'), 0.3], [$r('app.color.launch_ads_background'), 0.5],
        [$r('app.color.launch_ads_background'), 1.0]]
    })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}