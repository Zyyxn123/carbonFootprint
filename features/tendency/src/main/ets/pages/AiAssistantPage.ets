import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { dataType } from "../Model/DeepSeekModel"
import dpVM from "../ViewModel/DeepSeekViewModel"
import { Markdown } from "@luvi/lv-markdown-in"

@Component
export struct aiAssistantPage {
  @State textStr: string = ''
  private scroller = new Scroller()

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

      Column() {
        List({ space: 8, scroller: this.scroller }) {
          ForEach(dpVM.dataList, (item: dataType, index: number) => {
            ListItem() {
              Column() {
                Column() {
                  Text(item.que)
                    .fontSize(15)
                    .fontColor('#fff')
                }
                .borderRadius({ topLeft: 15, topRight: 5, bottomLeft: 15, bottomRight: 15 })
                .backgroundColor('#4285F4')
                .padding(10)
                .constraintSize({ maxWidth: '80%' })
              }
              .alignItems(HorizontalAlign.End)
              .width('100%')
            }

            ListItem() {
              Column() {
                Column() {
                  Markdown({ text: item.ans })
                    .width('95%')
                }
                .alignItems(HorizontalAlign.Center)
                .borderRadius({ topLeft: 5, topRight: 15, bottomLeft: 15, bottomRight: 15 })
                .backgroundColor('#F1F3F4')
                .padding(6)
                .constraintSize({ maxWidth: '95%' })
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')
            }
          })

          if (dpVM.currQues !== '') {
            ListItem() {
              Column() {
                Column() {
                  Text(dpVM.currQues)
                    .fontSize(15)
                    .fontColor('#fff')
                }
                .borderRadius({ topLeft: 15, topRight: 5, bottomLeft: 15, bottomRight: 15 })
                .backgroundColor('#4285F4')
                .padding(10)
                .constraintSize({ maxWidth: '80%' })
              }
              .alignItems(HorizontalAlign.End)
              .width('100%')
            }
          }

          if (dpVM.currAns !== '') {
            ListItem() {
              Column() {
                Column() {
                  Markdown({ text: dpVM.currAns })
                    .width('95%')
                }
                .alignItems(HorizontalAlign.Center)
                .borderRadius({ topLeft: 5, topRight: 15, bottomLeft: 15, bottomRight: 15 })
                .backgroundColor('#F1F3F4')
                .padding(6)
                .constraintSize({ maxWidth: '95%' })
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')
            }
          }
        }
        .padding({ left: 12, right: 12 })
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .width('100%')
        .onAttach(() => {
          this.scroller.scrollEdge(Edge.Bottom) // 组件挂载后立即滚动到底部
        })
        .stackFromEnd(true)
      }
      .layoutWeight(1)
      .margin({ bottom: 6 })

      Row({ space: 15 }) {
        TextInput({ placeholder: '理性发言，友善互动', text: $$this.textStr })
          .fontSize(16)
          .borderRadius(15)
          .padding(8)
          .width('80%')
          .placeholderColor('#ccc')
          .fontColor('#000')
          .backgroundColor('#fff6f6f6')

        Text('发送')
          .fontSize(17)
          .fontColor(this.textStr === '' ? '#ffa3bfec' : '#ff1c6df1')
          .onClick(() => {
            dpVM.getQues(this.textStr)
            this.textStr = ''
          })
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