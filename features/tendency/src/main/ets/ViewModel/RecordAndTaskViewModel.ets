import { RecordAndTaskTypeModel } from "../Model/RecordAndTaskModel"

@ObservedV2
class RecordAndTaskViewModel {
  @Trace RecordAndTask: RecordAndTaskTypeModel[] = [
    {
      title: $r('app.string.recordTitle'),
      content: $r('app.string.recordContent'),
      uri: '',
      image: $r('app.media.carbonRecord'),
      backgroundColor: $r('app.color.record_background')
    },
    {
      title: $r('app.string.taskTitle'),
      content: $r('app.string.taskContent'),
      uri: '',
      image: $r('app.media.carbonReductionTask'),
      backgroundColor: $r('app.color.task_background')
    }
  ]
}

export default new RecordAndTaskViewModel()