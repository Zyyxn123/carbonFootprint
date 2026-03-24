import { TaskMsgType } from "@ohos/utils"
import lowTVM from "../ViewModel/LowTaskViewModel"

@Component
export struct toDoTasksList {
  getBgColor(category: string): string {
    const colorMap: Record<string, string> = {
      '出行': '#42B983',
      '饮食': '#FF9A6C',
      '电器': '#5B9DFF',
      '节水': '#61D2C4',
      '生活习惯': '#A188FF',
      '消费': '#FF7575',
      '办公': '#91CA69',
      '绿植': '#52C41A',
      '环保': '#52C41A'
    }
    return colorMap[category] || '#999'
  }

  getTextColor(category: string): string {
    const textColorMap: Record<string, string> = {
      '出行': '#2A8A5F',
      '饮食': '#E07B4F',
      '电器': '#3A7BD5',
      '节水': '#45AFA3',
      '生活习惯': '#7A67D9',
      '消费': '#D95A5A',
      '办公': '#6CA843',
      '绿植': '#3A9112',
      '环保': '#3A9112'
    }
    return textColorMap[category] || '#555'
  }

  getLightBgColor(category: string): string {
    const lightColorMap: Record<string, string> = {
      '出行': '#E6F5F0',
      '饮食': '#FFF0E8',
      '电器': '#EDF4FF',
      '节水': '#E6F7F5',
      '生活习惯': '#F2EEFF',
      '消费': '#FFEFEF',
      '办公': '#F3F9EC',
      '绿植': '#F0F9E8',
      '环保': '#F0F9E8'
    }
    return lightColorMap[category] || '#F5F5F5'
  }

  @Builder
  tasksBuilder(item: TaskMsgType, index: number) {
    Column({ space: 10 }) {
      Text(item.taskItem.categoryIcon + ' ' + item.taskItem.category)
        .padding(6)
        .fontSize(12)
        .fontColor(this.getTextColor(item.taskItem.category))
        .backgroundColor(this.getBgColor(item.taskItem.category))
        .borderRadius(15)

      Text(item.taskItem.title)
        .fontSize(18)
        .fontColor('#000')
        .fontWeight(600)

      Text(item.taskItem.description)
        .fontSize(15)
        .fontColor('#ccc')
        .fontWeight(600)

      Row() {
        Text('+ ' + item.taskItem.co2Reduction.toString() + 'g CO₂减排')
          .fontColor('#37800f')
          .fontSize(16)

        Button(item.isFinished ? '已完成' : '标记完成')
          .backgroundColor(item.isFinished ? '#ff8c8c8c' : '#37800f')
          .fontColor(item.isFinished ? '#ccc' : '#fff')
          .onClick(async () => {
            if (!item.isFinished) {
              await lowTVM.updateData(index)

              AppStorage.set('tasksBol', true)
              setTimeout(async () => {
                const index = await lowTVM.findFirstUnfinishedIndex()
                AppStorage.set('showIndex', index)
                AppStorage.set('tasksBol', false)
              }, 1000)
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height(150)
    .backgroundColor(this.getLightBgColor(item.taskItem.category))
    .border({ width: { bottom: 1, right: 1 }, color: '#ccc', radius: 15 })
    .padding(10)
  }

  build() {
    Column({ space: 10 }) {
      ForEach(lowTVM.taskList, (item: TaskMsgType, index: number) => {
        this.tasksBuilder(item, index)
      })
    }
  }
}