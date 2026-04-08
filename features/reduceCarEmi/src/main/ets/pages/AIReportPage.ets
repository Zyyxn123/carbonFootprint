import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { ReportBack } from "../Components/ReportBack"
import aiReportVM from "../ViewModel/AIReportViewModel"
import { Markdown } from "@luvi/lv-markdown-in"

@Component
export struct AIReportPage {
  build() {
    Column() {
      ReportBack({ pageTitle: '你的专属报告' })

      Column() {
        List() {
          ListItem() {
            Column() {
              Markdown({ text: aiReportVM.showTextStr })
                .width('95%')
            }
            .padding(10)
            .width('100%')
            .backgroundColor('#F1F3F4')
            .borderRadius(12)
          }
        }
        .stackFromEnd(true)
        .padding(10)
        .width('100%')
      }
      .layoutWeight(1)
      .margin({ bottom: 6 })

      Column() {}
      .height(20)
      .width('100%')
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    AIReportPage()
  }
  .hideTitleBar(true)
  .title('AIReportPage')
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_reducecaremi_aiReportPage
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}