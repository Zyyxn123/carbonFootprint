import { TaskMsgType, TasksDataType } from "@ohos/utils"
import { LowTaskModel } from "../Model/LowTaskModel"
import { JSON } from "@kit.ArkTS"

@ObservedV2
class LowTaskViewModel {
  @Trace taskList: TaskMsgType[] = []
  @Trace id: number = -1
  @Trace recordDate: string = ''
  @Trace tasksMsg: string = ''
  @Trace acc: string = ''

  public async getTotalData(acc: string, date: string) {
    const dataItem: TasksDataType = await LowTaskModel.getTodayData(acc, date)
    this.id = dataItem.id
    this.recordDate = dataItem.recordDate
    this.tasksMsg = dataItem.tasksMsg
    this.acc = dataItem.account
    this.taskList = JSON.parse(dataItem.tasksMsg) as TaskMsgType[]
  }

  public async updateData(index: number) {
    if (index < 0 || index >= this.taskList.length) {
      return;
    }
    const newTaskList: TaskMsgType[] = []

    for (let i = 0; i < this.taskList.length; i++) {
      const currentItem = this.taskList[i]

      if (i === index) {
        const updatedItem: TaskMsgType = {
          taskItem: currentItem.taskItem,
          isFinished: true
        }
        newTaskList.push(updatedItem)
      } else {
        newTaskList.push(currentItem)
      }
    }

    this.taskList = newTaskList
    this.tasksMsg = JSON.stringify(this.taskList)

    LowTaskModel.updateData({
      id: this.id,
      account: this.acc,
      recordDate: this.recordDate,
      tasksMsg: this.tasksMsg
    } as TasksDataType, new Date().toLocaleDateString())
  }

  public findFirstUnfinishedTask(): TaskMsgType | null {
    if (!this.taskList || this.taskList.length === 0) {
      return null
    }

    for (let i = 0; i < this.taskList.length; i++) {
      const item = this.taskList[i]
      if (item && item.isFinished === false) {
        return item
      }
    }

    return null
  }

  public async findFirstUnfinishedIndex(): Promise<number> {
    return new Promise((resolve) => {
      if (!this.taskList || this.taskList.length === 0) {
        resolve(-1)
      }

      for (let i = 0; i < this.taskList.length; i++) {
        const item = this.taskList[i]
        if (item && item.isFinished === false) {
          console.log('LowTaskViewModel: ' + i)
          resolve(i)
        }
      }
      resolve(-1)
    })
  }
}

const lowTVM: LowTaskViewModel = new LowTaskViewModel()

export default lowTVM