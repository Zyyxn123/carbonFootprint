import { cardsDataTypeModel, popBoxDataTypeModel, transportsTypeModel } from "../Model/ToDoItemsModel"

@ObservedV2
class houseApplicationViewModel {
  @Trace cardsData: cardsDataTypeModel[] = [
    // 上排左侧：总用电碳排放
    {
      text: '累计碳排',
      num: 28.7,
      unit: 'kgCO₂'
    },
    // 上排右侧：本月用电碳排放
    {
      text: '本月目标完成度 68%',
      num: 12.4,
      unit: 'kgCO₂'
    },
    // 下排左侧：低碳用电天数
    {
      text: '低碳用电',
      num: 8,
      unit: '天',
      img: $r('app.media.icon_bulb') // 节能灯泡图标
    }
  ]
  @Trace popBoxData: popBoxDataTypeModel[] = [
    // 展开后第一行左侧：本月用电次数
    {
      text: '本月用电次数',
      num: 22,
      unit: ''
    },
    // 展开后第一行右侧：本月总耗电量
    {
      text: '本月总耗电',
      num: 36.2,
      unit: '度'
    },
    // 展开后第二行左侧：获得节能积分
    {
      text: '获得节能积分',
      num: 98,
      unit: ''
    },
    // 展开后第二行右侧：节能勋章
    {
      text: '节能勋章',
      num: 2,
      unit: ''
    }
  ]
  @Trace applicationsLists: transportsTypeModel[] = [
    {
      ts: '冰箱',
      tsc: '#2196F3',
      bgc: '#0F4C81',
      img: $r('app.media.appliances_bingxiang'),
      carEmissionPer: 120, // 每小时使用碳排放（克CO₂）
      pointsPerOrder: 7
    },
    {
      ts: '空调',
      tsc: '#03A9F4',
      bgc: '#0B699E',
      img: $r('app.media.appliances_kongtiao'),
      carEmissionPer: 800, // 每小时使用碳排放
      pointsPerOrder: 3
    },
    {
      ts: '电饭煲',
      tsc: '#FF9800',
      bgc: '#6B4423',
      img: $r('app.media.appliances_dianfanbao'),
      carEmissionPer: 350, // 每小时使用碳排放
      pointsPerOrder: 5
    },
    {
      ts: '洗衣机',
      tsc: '#009688',
      bgc: '#004D40',
      img: $r('app.media.appliances_xiyiji'),
      carEmissionPer: 280, // 每小时使用碳排放
      pointsPerOrder: 6
    },
    {
      ts: '电视机',
      tsc: '#9C27B0',
      bgc: '#4A148C',
      img: $r('app.media.appliances_dianshiji'),
      carEmissionPer: 60, // 每小时使用碳排放
      pointsPerOrder: 8
    },
    {
      ts: '电脑',
      tsc: '#607D8B',
      bgc: '#34495E',
      img: $r('app.media.appliances_diannao'),
      carEmissionPer: 75, // 每小时使用碳排放
      pointsPerOrder: 8
    },
    {
      ts: '电热水器',
      tsc: '#F44336',
      bgc: '#B71C1C',
      img: $r('app.media.appliances_dianreshuiqi'),
      carEmissionPer: 1500, // 每小时使用碳排放
      pointsPerOrder: 2
    },
    {
      ts: '电风扇',
      tsc: '#4CAF50',
      bgc: '#2D5F2E',
      img: $r('app.media.appliances_dianfengshan'),
      carEmissionPer: 15, // 每小时使用碳排放
      pointsPerOrder: 9
    },
    {
      ts: '微波炉',
      tsc: '#FF5722',
      bgc: '#5D4037',
      img: $r('app.media.appliances_weibolu'),
      carEmissionPer: 420, // 每小时使用碳排放
      pointsPerOrder: 4
    },
    {
      ts: '电磁炉',
      tsc: '#795548',
      bgc: '#3E2723',
      img: $r('app.media.appliances_diancilu'),
      carEmissionPer: 650, // 每小时使用碳排放
      pointsPerOrder: 4
    },
    {
      ts: '吸尘器',
      tsc: '#9E9E9E',
      bgc: '#424242',
      img: $r('app.media.appliances_xichenqi'),
      carEmissionPer: 200, // 每小时使用碳排放
      pointsPerOrder: 6
    },
    {
      ts: '更多',
      tsc: '#9E9E9E',
      bgc: '#424242',
      img: $r('app.media.func_add'),
      carEmissionPer: 0, // 通用选项暂赋值0
      pointsPerOrder: 1
    }
  ]
  @Trace title: string = '选择你使用的电器'
  // @Trace subHeading: string = '出行足迹'
}

// 导出实例，方便页面调用
export default new houseApplicationViewModel()