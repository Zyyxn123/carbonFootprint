import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"
import { RecordAndTaskTypeModel } from "../Model/RecordAndTaskModel"
import RecordAndTaskViewModel from "../ViewModel/RecordAndTaskViewModel"

@Component
export struct carbonRecordAndTasks {
  @Builder
  RecAndTaskBuilder(item: RecordAndTaskTypeModel, index: number) {
    Row() {
      Column() {
        Text(item.title)
          .fontSize(16)
          .width(80)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.recAndTask_title_color'))
          .margin({ left: 15, top: 10, bottom: 6 })
          .fontWeight(600)

        Row() {
          Text(item.content)
            .fontSize(12)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.recAndTask_content_color'))
            .margin(4)
        }
        .borderRadius(15)
        .backgroundColor($r('app.color.recAndTask_background'))
        .justifyContent(FlexAlign.Start)
        .padding(3)
        .margin({ left: 15 })

        Image(item.image)
          .width(index === 0 ? 80 : 90)
          .margin(index === 0 ? { left: 70, top: 20 } : { left: 70, top: 30 })
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height(180)
      .width('48%')
      .border({ width: 1, color: '#ffcdcdcd', radius: 15 })
      .linearGradient({
        angle: 45,
        colors: [[item.backgroundColor, 0.4], ['#ffffff', 0.6]]
      })
      .onClick(() => {
        buildRouterModel(RouterNameConstants.ENTRY_HAP, item.uri)
      })

      Column({ space: 15 }) {
        Divider()
          .vertical(false)
          .color(Color.Black)
          .strokeWidth(5)
          .width(15)
        Divider()
          .vertical(false)
          .color(Color.Black)
          .strokeWidth(5)
          .width(15)
      }

      Column() {
        Column() {
          Text(index === 0 ? '在可视化地图上标记你的每一次低碳出行与环保生活轨迹，直观留存每一个绿色选择印记，清晰看见个人减碳行动的真实足迹，让环保行为可追溯、可感知。'
            : '完成每日专属减碳任务即可累积绿色贡献积分，在趣味化挑战中践行低碳理念，用点滴行动累积个人环保贡献值，让减碳成为轻松可坚持的生活习惯。')
            .fontSize(15)
            .fontColor('#000')
            .margin(5)
            .lineHeight(18)
        }
        .width('95%')
        .height(170)
        .margin(5)
        .borderRadius(15)
        .backgroundBlurStyle(BlurStyle.Thin,
          { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 1.0 })
      }
      .width('48%')
      .height(180)
      .border({ width: 1, color: '#ccc', radius: 15 })

      // .backgroundImage(index === 0 ? $r('app.media.bg_footprint') : $r('app.media.bg_Task'))
      // .backgroundImagePosition(Alignment.Bottom)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column({ space: 15 }) {
      ForEach(RecordAndTaskViewModel.RecordAndTask,
        (item: RecordAndTaskTypeModel, index: number) => {
          this.RecAndTaskBuilder(item, index)
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}

