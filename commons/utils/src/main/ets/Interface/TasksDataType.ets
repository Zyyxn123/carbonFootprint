export interface TasksDataType {
  id: number
  account: string
  recordDate: string
  tasksMsg: string
}

export interface TaskMsgType {
  taskItem: CarbonTask
  isFinished: boolean
}

export interface CarbonTask {
  id: string;           // 任务唯一ID
  category: string;     // 分类：出行/饮食/电器/节水/生活习惯/消费/办公/绿植
  categoryIcon: string; // 分类图标（emoji）
  title: string;        // 任务标题
  description: string;  // 任务描述
  co2Reduction: number; // 减排量（单位：g CO₂）
}