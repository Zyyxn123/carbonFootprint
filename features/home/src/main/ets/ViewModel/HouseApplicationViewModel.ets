import {
  applicationsCardsDataTypeModel,
  applicationsPopBoxDataTypeModel, applicationsTypeModel } from "../Model/HouseApplicationModel"

@ObservedV2
class houseApplicationViewModel {
  @Trace cardsData: applicationsCardsDataTypeModel[] = [
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
  @Trace popBoxData: applicationsPopBoxDataTypeModel[] = [
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
  @Trace transportLists: applicationsTypeModel[] = [
    {
      ts: '骑行',
      tsc: '#4CAF50', // 亮绿（图标色）
      bgc: '#2D5F2E',  // 深橄榄绿（背景圆）
      img: $r('app.media.transports_zixingche') // 自行车图标
    },
    {
      ts: '步行',
      tsc: '#FFC107', // 亮黄（图标色）
      bgc: '#6B5A1E',  // 深棕黄（背景圆）
      img: $r('app.media.transports_buxing') // 步行图标
    },
    {
      ts: '电动车',
      tsc: '#E91E63', // 亮粉紫（图标色）
      bgc: '#4A235A',  // 深紫（背景圆）
      img: $r('app.media.transports_diandongche') // 电动车图标
    },
    {
      ts: '公交车',
      tsc: '#2196F3', // 亮蓝（图标色）
      bgc: '#0F4C81',  // 深蓝（背景圆）
      img: $r('app.media.transports_gongjiaoche') // 公交车图标
    },
    {
      ts: '地铁',
      tsc: '#4CAF50', // 亮绿（图标色）
      bgc: '#2D5F2E',  // 深橄榄绿（背景圆）
      img: $r('app.media.transports_ditie') // 地铁图标
    },
    {
      ts: '高铁',
      tsc: '#FF9800', // 亮橙（图标色）
      bgc: '#6B4423',  // 深棕橙（背景圆）
      img: $r('app.media.transports_gaotie') // 高铁图标
    },
    {
      ts: '火车',
      tsc: '#795548', // 棕灰（图标色）
      bgc: '#3E2723',  // 深棕（背景圆）
      img: $r('app.media.transports_huoche') // 火车图标
    },
    {
      ts: '飞机',
      tsc: '#3F51B5', // 靛蓝（图标色）
      bgc: '#1A237E',  // 深靛蓝（背景圆）
      img: $r('app.media.transports_feiji') // 飞机图标
    },
    {
      ts: '邮轮',
      tsc: '#009688', // 青绿色（图标色）
      bgc: '#004D40',  // 深青（背景圆）
      img: $r('app.media.transports_youlun') // 邮轮图标
    },
    {
      ts: '私家车',
      tsc: '#FF5722', // 亮橙红（图标色）
      bgc: '#5D4037',  // 深棕橙（背景圆）
      img: $r('app.media.transports_sijiache') // 私家车（私家车）图标
    },
    {
      ts: '长途',
      tsc: '#8BC34A', // 亮浅绿（图标色）
      bgc: '#33691E',  // 深墨绿（背景圆）
      img: $r('app.media.transports_gongjiaoche') // 暂用公交车图标，后续可替换为长途客车专属图标
    },
    {
      ts: '更多',
      tsc: '#9E9E9E', // 浅灰（图标色，通用中性色）
      bgc: '#424242',  // 深灰（背景圆，匹配“更多”的通用属性）
      img: $r('app.media.func_add') // 替换为你的“更多”通用图标
    }
  ]
  @Trace title: string = '选择你使用的电器'
  // @Trace subHeading: string = '出行足迹'
}

// 导出实例，方便页面调用
export default new houseApplicationViewModel()