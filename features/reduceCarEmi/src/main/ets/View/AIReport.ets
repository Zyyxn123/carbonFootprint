import { HTTPForAIReport } from "@ohos/utils"
import aiReportVM from "../ViewModel/AIReportViewModel"

@Component
export struct AIReport {
  @State hasContent: boolean = false
  @State @Watch('returnData') fullText: string = "" // 🔥 最终完整文字
  @State displayText: string = "" // 🔥 逐字显示的文字

  returnData(propName: string) {

  }

  build() {
    Column({ space: 10 }) {
      Text('AI智能减排推荐报告')
        .width('100%')
        .textAlign(TextAlign.Start)
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#000')
        .margin({ left: 5, top: 18 })

      Column() {
        Row({ space: 6 }) {
          Image($r('app.media.reEmi_aiReport'))
            .width(20)
            .fillColor('#2E7D32')

          Text('碳排现状分析')
            .fontSize(17)
            .fontColor('#000')
            .layoutWeight(1)

          Text('展开全部')
            .fontSize(16)
            .fontColor('#2E7D32')
        }
        .width('100%')
        .margin({ bottom: 5 })

        if (this.hasContent || aiReportVM.showTextStr !== '') {
          Text() {
            Span(aiReportVM.showTextStr)
            Span(aiReportVM.isOk ? '' : '...')
          }
          .textAlign(TextAlign.Start)
          .fontColor('#000')
          .fontSize(14)
          .width('100%')
          .animation({ duration: 600 })
        } else {
          Column() {
            Button('获取报告')
              .width('50%')
              .height(40)
              .fontSize(16)
              .fontColor('#fff')
              .backgroundColor('#37800f')
              .onClick(async () => {
                await aiReportVM.getMsg()
                this.hasContent = true
              })
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .width('100%')
          .height('100%')
        }
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .height(200)
      .padding(10)
      .border({ width: 1, radius: 15, color: '#ccc' })
      .backgroundColor('#fff')
    }
    .padding({ left: 10, right: 10, bottom: 5 })
    .width('100%')
    .backgroundColor('#fff6f6f6')
    .borderRadius({ topLeft: 25, topRight: 25 })
    .border({ width: { top: 2 }, color: '#ccc' })
    .margin({ top: 15 })
  }
}