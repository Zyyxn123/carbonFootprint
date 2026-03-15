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
      tsc: '#8D6E63', // 亮米棕（图标色，贴合主食属性）
      bgc: '#5D4037',  // 深棕（背景圆）
      img: $r('app.media.food_mifan') // 米饭图标
    },
    {
      ts: '青菜',
      tsc: '#4CAF50', // 亮绿（图标色，贴合蔬菜低碳属性）
      bgc: '#2D5F2E',  // 深橄榄绿（背景圆）
      img: $r('app.media.food_qingcai') // 青菜图标
    },
    {
      ts: '猪肉',
      tsc: '#E57373', // 亮红粉（图标色，贴合肉类属性）
      bgc: '#B71C1C',  // 深红（背景圆）
      img: $r('app.media.food_zhurou') // 猪肉图标
    },
    {
      ts: '鸡蛋',
      tsc: '#FFC107', // 亮黄（图标色，贴合蛋类属性）
      bgc: '#6B5A1E',  // 深棕黄（背景圆）
      img: $r('app.media.food_jidan') // 鸡蛋图标
    },
    {
      ts: '牛奶',
      tsc: '#F5F5F5', // 亮白（图标色，贴合乳制品属性）
      bgc: '#9E9E9E',  // 深灰（背景圆）
      img: $r('app.media.food_niunai') // 牛奶图标
    },
    {
      ts: '咖啡',
      tsc: '#795548', // 棕灰（图标色，贴合饮品属性）
      bgc: '#3E2723',  // 深棕（背景圆）
      img: $r('app.media.food_kafei') // 咖啡图标
    },
    {
      ts: '苹果',
      tsc: '#F44336', // 亮红（图标色，贴合水果属性）
      bgc: '#C62828',  // 深红（背景圆）
      img: $r('app.media.food_pingguo') // 苹果图标
    },
    {
      ts: '豆制品',
      tsc: '#FFEB3B', // 亮浅黄（图标色，贴合豆类属性）
      bgc: '#F57F17',  // 深黄（背景圆）
      img: $r('app.media.food_douzhipin') // 豆制品图标
    },
    {
      ts: '鸡肉',
      tsc: '#FFCCBC', // 亮浅橙（图标色，贴合禽类属性）
      bgc: '#8D6E63',  // 深棕（背景圆）
      img: $r('app.media.food_jirou') // 鸡肉图标
    },
    {
      ts: '饮用水',
      tsc: '#2196F3', // 亮蓝（图标色，贴合水属性）
      bgc: '#0F4C81',  // 深蓝（背景圆）
      img: $r('app.media.food_yinyongshui') // 饮用水图标
    },
    {
      ts: '面包',
      tsc: '#FF9800', // 亮橙（图标色，贴合主食属性）
      bgc: '#E65100',  // 深橙（背景圆）
      img: $r('app.media.food_mianbao') // 面包图标
    },
    {
      ts: '更多',
      tsc: '#9E9E9E', // 浅灰（通用图标色）
      bgc: '#424242',  // 深灰（背景圆）
      img: $r('app.media.func_add') // 更多通用图标
    }
  ]
  @Trace title: string = '请选择你的饮食'
  // @Trace subHeading: string = '出行足迹'
}

export default new foodAndDrinkViewModel()