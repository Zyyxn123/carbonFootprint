import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"

@Component
export struct aiAssistantPage {
  @State textStr: string = ''
  build() {
    Column() {
      Row({ space: 10 }) {
        Image($r('app.media.arrow_up'))
          .width(38)
          .rotate({ angle: -90 })
          .backgroundColor('#ccc')
          .fillColor('#37800f')
          .padding(10)
          .borderRadius(25)
          .onClick(() => {
            AppStorage.set('expandSafeArea', false)
            RouterModule.pop(RouterNameConstants.ENTRY_HAP)
          })

        Text('ai 小助手')
          .fontSize(26)
          .fontColor('#000000')
          .fontWeight(700)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({ top: 35, left: 20, bottom: 10 })
      .margin({ bottom: 5 })
      // .backgroundBlurStyle(BlurStyle.Thin,
      //   { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 1.0 })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.END])

      List() {

      }
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .width('100%')
      .layoutWeight(1)

      Row({ space: 15 }) {
        TextInput({ placeholder: '理性发言，友善互动', text: $$this.textStr})
          .fontSize(16)
          .borderRadius(15)
          .padding(8)
          .width('80%')
          .fontColor('#ccc')
          .backgroundColor('#fff6f6f6')

        Text('发送')
          .fontSize(17)
          .fontColor(this.textStr === '' ? '#ffa3bfec' : '#ff1c6df1')
      }
      .width('100%')
      .height(70)
      .backgroundColor('#fff')
      .padding({ top: 3, left: 20, bottom: 20 })
      .border({ width: { top: 1 }, color: '#ccc' })
    }
    .backgroundColor('#fff')
    .width('100%')
    .height('100%')
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    aiAssistantPage()
  }
  .hideTitleBar(true)
  .title('aiAssistantPage')
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_tendency_aiAssistant
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}