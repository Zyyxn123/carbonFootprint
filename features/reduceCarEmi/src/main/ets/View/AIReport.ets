import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"
import { HTTPForAIReport, ReduceCarEmiPreference } from "@ohos/utils"
import aiReportVM from "../ViewModel/AIReportViewModel"

@Component
export struct AIReport {
  @State hasContent: boolean = false
  @State @Watch('returnData') fullText: string = ""
  @State displayText: string = ""

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
            .onClick(async () => {
              buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_reducecaremi_aiReportPage)
            })
        }
        .width('100%')
        .margin({ bottom: 5 })

        if (this.hasContent || aiReportVM.showTextStr !== '') {
          Text() {
            Span(this.filterMarkdown(aiReportVM.showTextStr.trim()))
            Span(aiReportVM.isOk ? '' : '...')
          }
          .maxLines(10)
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
                const acc: string = AppStorage.get('currLoginAcc') as string
                const bol: boolean = await aiReportVM.getMsg(acc)
                if (bol === false) {
                  this.getUIContext().getPromptAction().showToast({
                    message: `已有数据，请${aiReportVM.getRemainRequestDays()}后再次获取`,
                    duration: 1000,
                    bottom: 80
                  })
                } else {
                  buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_reducecaremi_aiReportPage)
                }
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

  filterMarkdown(str: string): string {
    if (!str) return '';

    // 正则规则：只保留 中文汉字、中文标点（。，！？；：“”‘’（）【】《》…—）
    return str.replace(/[^\u4e00-\u9fa5\u3002\uff0c\uff01\uff1f\uff1b\uff1a\u201c\u201d\u2018\u2019\uff08\uff09\u3010\u3011\u300a\u300b\u2026\u2014]/g, '');
  }
}