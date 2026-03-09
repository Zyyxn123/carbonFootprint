import { RecordAndTaskTypeModel } from "../Model/RecordAndTaskModel"
import RecordAndTaskViewModel from "../ViewModel/RecordAndTaskViewModel"

@Component
export struct carbonRecordAndTasks {
  @Builder
  RecAndTaskBuilder(item: RecordAndTaskTypeModel, index: number) {
    Column() {
      Text(item.title)
        .fontSize(16)
        .width('100%')
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
      angle: 60,
      colors: [[item.backgroundColor, 0.2], ['#ffffff', 0.4]]
    })
  }

  build() {
    Row({ space: 15 }) {
      ForEach(RecordAndTaskViewModel.RecordAndTask,
        (item: RecordAndTaskTypeModel, index: number) => {
          this.RecAndTaskBuilder(item, index)
        })
    }
    .width('100%')
  }
}