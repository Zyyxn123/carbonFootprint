import { BuilderNameConstants } from "@ohos/customrouter"
import { RecordAndTaskTypeModel } from "../Model/RecordAndTaskModel"

@ObservedV2
class RecordAndTaskViewModel {
  @Trace RecordAndTask: RecordAndTaskTypeModel[] = [
    {
      title: $r('app.string.recordTitle'),
      content: $r('app.string.recordContent'),
      uri: BuilderNameConstants.HAR_tendency_lowFootprint,
      image: $r('app.media.tendency_bird'),
      backgroundColor: $r('app.color.record_background')
    },
    {
      title: $r('app.string.taskTitle'),
      content: $r('app.string.taskContent'),
      uri: BuilderNameConstants.HAR_tendency_lowTask,
      image: $r('app.media.tendency_turtle'),
      backgroundColor: $r('app.color.task_background')
    }
  ]
}

export default new RecordAndTaskViewModel()