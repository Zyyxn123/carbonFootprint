import { cardsDataTypeModel, popBoxDataTypeModel, transportsTypeModel } from '../Model/ToDoItemsModel'

@ObservedV2
class foodAndDrinkViewModel {
  @Trace cardsData: cardsDataTypeModel[] = [
    // 上排左侧：总饮食碳排（核心数据）
    {
      text: '累计碳排',
      num: 45.2,
      unit: 'kgCO₂'
    },
    // 上排右侧：本月饮食碳排 + 目标完成度
    {
      text: '本月目标完成度 82%',
      num: 18.9,
      unit: 'kgCO₂'
    },
    // 下排左侧：低碳饮食天数（带专属图标）
    {
      text: '低碳饮食',
      num: 10,
      unit: '天',
      img: $r('app.media.icon_vegetable') // 蔬菜/麦穗图标，适配饮食场景
    }
  ]
  @Trace popBoxData: popBoxDataTypeModel[] = [
    // 展开后第一行左侧：本月饮食次数
    {
      text: '本月饮食次数',
      num: 42,
      unit: ''
    },
    // 展开后第一行右侧：本月本地食材占比
    {
      text: '本地食材占比',
      num: 65,
      unit: '%'
    },
    // 展开后第二行左侧：获得低碳饮食积分
    {
      text: '低碳饮食积分',
      num: 156,
      unit: ''
    },
    // 展开后第二行右侧：低碳饮食勋章
    {
      text: '低碳勋章',
      num: 4,
      unit: ''
    }
  ]
  @Trace foodAndDrinkLists: transportsTypeModel[] = [
    {
      ts: '米饭',
      tsc: '#8D6E63',
      bgc: '#5D4037',
      img: $r('app.media.food_mifan'),
      carEmissionPer: 11, // 100克米饭碳排放（克CO₂）
      pointsPerOrder: 7
    },
    {
      ts: '青菜',
      tsc: '#4CAF50',
      bgc: '#2D5F2E',
      img: $r('app.media.food_qingcai'),
      carEmissionPer: 2, // 100克青菜碳排放
      pointsPerOrder: 9
    },
    {
      ts: '猪肉',
      tsc: '#E57373',
      bgc: '#B71C1C',
      img: $r('app.media.food_zhurou'),
      carEmissionPer: 1280, // 100克猪肉碳排放
      pointsPerOrder: 2
    },
    {
      ts: '鸡蛋',
      tsc: '#FFC107',
      bgc: '#6B5A1E',
      img: $r('app.media.food_jidan'),
      carEmissionPer: 300, // 100克鸡蛋碳排放
      pointsPerOrder: 5
    },
    {
      ts: '牛奶',
      tsc: '#F5F5F5',
      bgc: '#9E9E9E',
      img: $r('app.media.food_niunai'),
      carEmissionPer: 190, // 100毫升牛奶碳排放
      pointsPerOrder: 6
    },
    {
      ts: '咖啡',
      tsc: '#795548',
      bgc: '#3E2723',
      img: $r('app.media.food_kafei'),
      carEmissionPer: 180, // 100毫升咖啡碳排放
      pointsPerOrder: 6
    },
    {
      ts: '苹果',
      tsc: '#F44336',
      bgc: '#C62828',
      img: $r('app.media.food_pingguo'),
      carEmissionPer: 35, // 100克苹果碳排放
      pointsPerOrder: 8
    },
    {
      ts: '豆制品',
      tsc: '#FFEB3B',
      bgc: '#F57F17',
      img: $r('app.media.food_douzhipin'),
      carEmissionPer: 20, // 100克豆制品碳排放
      pointsPerOrder: 8
    },
    {
      ts: '鸡肉',
      tsc: '#FFCCBC',
      bgc: '#8D6E63',
      img: $r('app.media.food_jirou'),
      carEmissionPer: 440, // 100克鸡肉碳排放
      pointsPerOrder: 4
    },
    {
      ts: '饮用水',
      tsc: '#2196F3',
      bgc: '#0F4C81',
      img: $r('app.media.food_yinyongshui'),
      carEmissionPer: 0.5, // 100毫升饮用水碳排放
      pointsPerOrder: 10
    },
    {
      ts: '面包',
      tsc: '#FF9800',
      bgc: '#E65100',
      img: $r('app.media.food_mianbao'),
      carEmissionPer: 80, // 100克面包碳排放
      pointsPerOrder: 7
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
  @Trace title: string = '请选择你的饮食'
  // @Trace subHeading: string = '出行足迹'
}

export default new foodAndDrinkViewModel()