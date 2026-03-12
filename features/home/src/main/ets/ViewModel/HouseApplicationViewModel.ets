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
  @Trace applicationsLists: applicationsTypeModel[] = [
    {
      ts: '冰箱',
      tsc: '#2196F3', // 亮蓝（图标色，贴合制冷属性）
      bgc: '#0F4C81',  // 深蓝（背景圆）
      img: $r('app.media.appliances_bingxiang') // 冰箱图标
    },
    {
      ts: '空调',
      tsc: '#03A9F4', // 亮浅蓝（图标色，清凉感）
      bgc: '#0B699E',  // 深浅蓝（背景圆）
      img: $r('app.media.appliances_kongtiao') // 空调图标
    },
    {
      ts: '电饭煲',
      tsc: '#FF9800', // 亮橙（图标色，贴合烹饪属性）
      bgc: '#6B4423',  // 深棕橙（背景圆）
      img: $r('app.media.appliances_dianfanbao') // 电饭煲图标
    },
    {
      ts: '洗衣机',
      tsc: '#009688', // 青绿色（图标色，贴合水属性）
      bgc: '#004D40',  // 深青（背景圆）
      img: $r('app.media.appliances_xiyiji') // 洗衣机图标
    },
    {
      ts: '电视机',
      tsc: '#9C27B0', // 亮紫（图标色，科技感）
      bgc: '#4A148C',  // 深紫（背景圆）
      img: $r('app.media.appliances_dianshiji') // 电视机图标
    },
    {
      ts: '电脑',
      tsc: '#607D8B', // 亮灰蓝（图标色，办公属性）
      bgc: '#34495E',  // 深灰蓝（背景圆）
      img: $r('app.media.appliances_diannao') // 电脑图标
    },
    {
      ts: '电热水器',
      tsc: '#F44336', // 亮红（图标色，热水属性）
      bgc: '#B71C1C',  // 深红（背景圆）
      img: $r('app.media.appliances_dianreshuiqi') // 电热水器图标
    },
    {
      ts: '电风扇',
      tsc: '#4CAF50', // 亮绿（图标色，节能属性）
      bgc: '#2D5F2E',  // 深橄榄绿（背景圆）
      img: $r('app.media.appliances_dianfengshan') // 电风扇图标
    },
    {
      ts: '微波炉',
      tsc: '#FF5722', // 亮橙红（图标色，加热属性）
      bgc: '#5D4037',  // 深棕橙（背景圆）
      img: $r('app.media.appliances_weibolu') // 微波炉图标
    },
    {
      ts: '电磁炉',
      tsc: '#795548', // 棕灰（图标色，厨具属性）
      bgc: '#3E2723',  // 深棕（背景圆）
      img: $r('app.media.appliances_diancilu') // 电磁炉图标
    },
    {
      ts: '吸尘器',
      tsc: '#9E9E9E', // 浅灰（图标色，清洁属性）
      bgc: '#424242',  // 深灰（背景圆）
      img: $r('app.media.appliances_xichenqi') // 吸尘器图标
    },
    {
      ts: '更多',
      tsc: '#9E9E9E', // 浅灰（通用图标色）
      bgc: '#424242',  // 深灰（背景圆）
      img: $r('app.media.func_add') // 更多通用图标
    }
  ]
  @Trace title: string = '选择你使用的电器'
  // @Trace subHeading: string = '出行足迹'
}

// 导出实例，方便页面调用
export default new houseApplicationViewModel()