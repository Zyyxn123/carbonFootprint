import { relationalStore } from "@kit.ArkData"
import { TendencySQL } from "../Constants/TendencySQL"
import { TendTasksLogger } from "../Hilog/HilogInfo"
import { CarbonTask, TaskMsgType, TasksDataType } from "../Interface/TasksDataType"
import { TendencyDBManager } from "./TendencyDBManager"
import { JSON } from "@kit.ArkTS"


export class TendTasksTable {
  private static instance: TendTasksTable
  private static carbonTasks: CarbonTask[] = [
    // ========== 出行类 (15个) ==========
    {
      id: "travel_01",
      category: "出行",
      categoryIcon: "🚲",
      title: "短途出行选择步行/共享单车",
      description: "绿色出行，减少机动车尾气排放",
      co2Reduction: 150
    },
    {
      id: "travel_02",
      category: "出行",
      categoryIcon: "🚇",
      title: "通勤选择地铁/公交",
      description: "替代私家车，降低人均碳排放",
      co2Reduction: 220
    },
    {
      id: "travel_03",
      category: "出行",
      categoryIcon: "🚗",
      title: "拼车通勤（≥2人同行）",
      description: "共享出行，减少车辆空驶率",
      co2Reduction: 200
    },
    {
      id: "travel_04",
      category: "出行",
      categoryIcon: "🚗",
      title: "减少5km内私家车出行",
      description: "短途优先低碳代步方式",
      co2Reduction: 300
    },
    {
      id: "travel_05",
      category: "出行",
      categoryIcon: "🚶",
      title: "≤5层步行上下楼",
      description: "节约电梯用电，减少能源消耗",
      co2Reduction: 40
    },
    {
      id: "travel_06",
      category: "出行",
      categoryIcon: "🚌",
      title: "周末出行选社区巴士",
      description: "低碳接驳，减少私家车使用",
      co2Reduction: 180
    },
    {
      id: "travel_07",
      category: "出行",
      categoryIcon: "🛴",
      title: "电动滑板车短途代步",
      description: "零排放，便捷环保",
      co2Reduction: 120
    },
    {
      id: "travel_08",
      category: "出行",
      categoryIcon: "🚗",
      title: "驾车保持匀速行驶",
      description: "避免急加速/急刹车，降低油耗",
      co2Reduction: 90
    },
    {
      id: "travel_09",
      category: "出行",
      categoryIcon: "🚗",
      title: "怠速≥3分钟及时熄火",
      description: "减少怠速尾气排放",
      co2Reduction: 60
    },
    {
      id: "travel_10",
      category: "出行",
      categoryIcon: "🚲",
      title: "骑行1公里替代驾车",
      description: "每公里减少约150g碳排放",
      co2Reduction: 150
    },
    {
      id: "travel_11",
      category: "出行",
      categoryIcon: "🚶",
      title: "步行10分钟替代打车",
      description: "健康+低碳双重收益",
      co2Reduction: 80
    },
    {
      id: "travel_12",
      category: "出行",
      categoryIcon: "🚄",
      title: "跨城出行选高铁/动车",
      description: "相比飞机，高铁碳排放更低",
      co2Reduction: 500
    },
    {
      id: "travel_13",
      category: "出行",
      categoryIcon: "🚶",
      title: "下班步行回家（≤2km）",
      description: "短程步行，零碳排放",
      co2Reduction: 100
    },
    {
      id: "travel_14",
      category: "出行",
      categoryIcon: "🚲",
      title: "周末骑行逛公园",
      description: "替代驾车出游，享受自然",
      co2Reduction: 160
    },
    {
      id: "travel_15",
      category: "出行",
      categoryIcon: "🚇",
      title: "错峰乘坐公共交通",
      description: "提高运力效率，减少拥堵能耗",
      co2Reduction: 70
    },

    // ========== 饮食类 (15个) ==========
    {
      id: "food_01",
      category: "饮食",
      categoryIcon: "🍽️",
      title: "午餐选择素食餐点",
      description: "素食一餐减少畜牧业碳排放约250g",
      co2Reduction: 250
    },
    {
      id: "food_02",
      category: "饮食",
      categoryIcon: "🥤",
      title: "自带水杯，拒绝一次性杯",
      description: "减少塑料杯生产和处理碳排放",
      co2Reduction: 50
    },
    {
      id: "food_03",
      category: "饮食",
      categoryIcon: "🍚",
      title: "践行光盘行动",
      description: "减少食物浪费，降低全链条碳排放",
      co2Reduction: 80
    },
    {
      id: "food_04",
      category: "饮食",
      categoryIcon: "🥡",
      title: "外卖选“无需一次性餐具”",
      description: "减少一次性筷子、餐盒使用",
      co2Reduction: 70
    },
    {
      id: "food_05",
      category: "饮食",
      categoryIcon: "🥩",
      title: "减少1次红肉摄入",
      description: "畜牧业碳排放高，替代为白肉/素食",
      co2Reduction: 300
    },
    {
      id: "food_06",
      category: "饮食",
      categoryIcon: "🥗",
      title: "晚餐选轻食沙拉",
      description: "减少食物加工环节能源消耗",
      co2Reduction: 120
    },
    {
      id: "food_07",
      category: "饮食",
      categoryIcon: "🍎",
      title: "购买本地应季蔬果",
      description: "降低长途运输和冷藏碳排放",
      co2Reduction: 160
    },
    {
      id: "food_08",
      category: "饮食",
      categoryIcon: "🍲",
      title: "剩菜合理储存不丢弃",
      description: "延长食物生命周期，减少浪费",
      co2Reduction: 90
    },
    {
      id: "food_09",
      category: "饮食",
      categoryIcon: "🍵",
      title: "自带环保杯买咖啡",
      description: "替代一次性纸杯，减少包装垃圾",
      co2Reduction: 60
    },
    {
      id: "food_10",
      category: "饮食",
      categoryIcon: "🥛",
      title: "选植物基饮品替代牛奶",
      description: "植物基饮品碳排放低于乳制品",
      co2Reduction: 180
    },
    {
      id: "food_11",
      category: "饮食",
      categoryIcon: "🍞",
      title: "自制早餐替代包装食品",
      description: "减少预包装食品生产运输碳排放",
      co2Reduction: 110
    },
    {
      id: "food_12",
      category: "饮食",
      categoryIcon: "🍻",
      title: "减少1次酒精类消费",
      description: "酿酒行业碳排放较高，适度消费更环保",
      co2Reduction: 140
    },
    {
      id: "food_13",
      category: "饮食",
      categoryIcon: "🥣",
      title: "用剩菜做新菜品",
      description: "创意利用剩菜，避免浪费",
      co2Reduction: 70
    },
    {
      id: "food_14",
      category: "饮食",
      categoryIcon: "🍵",
      title: "喝白开水替代瓶装饮料",
      description: "减少塑料瓶生产和运输碳排放",
      co2Reduction: 100
    },
    {
      id: "food_15",
      category: "饮食",
      categoryIcon: "🍽️",
      title: "分餐制避免过量点餐",
      description: "按需点餐，从源头减少食物浪费",
      co2Reduction: 120
    },

    // ========== 电器/能源类 (15个) ==========
    {
      id: "energy_01",
      category: "电器",
      categoryIcon: "🔌",
      title: "离开办公室关闭所有电器",
      description: "节约用电，减少能源消耗",
      co2Reduction: 100
    },
    {
      id: "energy_02",
      category: "电器",
      categoryIcon: "❄️",
      title: "夏季空调上调1℃（≥26℃）",
      description: "每上调1℃，日减排约120g",
      co2Reduction: 120
    },
    {
      id: "energy_03",
      category: "电器",
      categoryIcon: "🔥",
      title: "冬季空调下调1℃（≤20℃）",
      description: "降低供暖能耗，减少碳排放",
      co2Reduction: 130
    },
    {
      id: "energy_04",
      category: "电器",
      categoryIcon: "🧺",
      title: "用节能模式洗衣",
      description: "减少洗衣机耗电量和用水量",
      co2Reduction: 90
    },
    {
      id: "energy_05",
      category: "电器",
      categoryIcon: "💡",
      title: "随手关闭无人房间灯光",
      description: "避免空转耗电，节约电力",
      co2Reduction: 30
    },
    {
      id: "energy_06",
      category: "电器",
      categoryIcon: "💡",
      title: "更换白炽灯为LED灯",
      description: "LED灯能耗仅为白炽灯1/5",
      co2Reduction: 70
    },
    {
      id: "energy_07",
      category: "电器",
      categoryIcon: "📱",
      title: "充满电后拔下充电器",
      description: "避免待机耗电，减少能源浪费",
      co2Reduction: 20
    },
    {
      id: "energy_08",
      category: "电器",
      categoryIcon: "❄️",
      title: "冰箱门少开、快开快关",
      description: "减少冷量流失，降低压缩机能耗",
      co2Reduction: 50
    },
    {
      id: "energy_09",
      category: "电器",
      categoryIcon: "🔥",
      title: "用电磁炉替代燃气灶",
      description: "减少燃气燃烧的直接碳排放",
      co2Reduction: 150
    },
    {
      id: "energy_10",
      category: "电器",
      categoryIcon: "📺",
      title: "不看电视时彻底关机",
      description: "待机模式仍消耗约10%电量",
      co2Reduction: 40
    },
    {
      id: "energy_11",
      category: "电器",
      categoryIcon: "🌞",
      title: "白天利用自然光少开灯",
      description: "充分利用太阳能，减少电力消耗",
      co2Reduction: 60
    },
    {
      id: "energy_12",
      category: "电器",
      categoryIcon: "🔌",
      title: "拔掉不使用的插排电源",
      description: "消除“ phantom load ”待机耗电",
      co2Reduction: 80
    },
    {
      id: "energy_13",
      category: "电器",
      categoryIcon: "🧺",
      title: "攒满衣物再开洗衣机",
      description: "减少洗衣次数，节约水电",
      co2Reduction: 110
    },
    {
      id: "energy_14",
      category: "电器",
      categoryIcon: "🔥",
      title: "用锅盖焖煮食物",
      description: "锁住热量，缩短烹饪时间，节约燃气",
      co2Reduction: 60
    },
    {
      id: "energy_15",
      category: "电器",
      categoryIcon: "❄️",
      title: "冰箱内食物不过满",
      description: "保证冷气循环，提高制冷效率",
      co2Reduction: 40
    },

    // ========== 节水类 (10个) ==========
    {
      id: "water_01",
      category: "节水",
      categoryIcon: "💧",
      title: "用节水模式清洗衣物",
      description: "节约用水，减少污水处理碳排放",
      co2Reduction: 80
    },
    {
      id: "water_02",
      category: "节水",
      categoryIcon: "🚰",
      title: "洗手时及时关水龙头",
      description: "避免长流水，节约每一滴水",
      co2Reduction: 30
    },
    {
      id: "water_03",
      category: "节水",
      categoryIcon: "🚿",
      title: "淋浴时间缩短5分钟",
      description: "减少热水使用，降低烧水能耗",
      co2Reduction: 100
    },
    {
      id: "water_04",
      category: "节水",
      categoryIcon: "🚽",
      title: "使用马桶节水按钮",
      description: "减少冲厕用水量，节约水资源",
      co2Reduction: 20
    },
    {
      id: "water_05",
      category: "节水",
      categoryIcon: "💧",
      title: "用盆接水洗菜",
      description: "替代流水冲洗，节约用水量",
      co2Reduction: 50
    },
    {
      id: "water_06",
      category: "节水",
      categoryIcon: "🚰",
      title: "收集雨水浇花",
      description: "替代自来水，节约市政供水",
      co2Reduction: 40
    },
    {
      id: "water_07",
      category: "节水",
      categoryIcon: "🚿",
      title: "洗澡时先放冷水接桶",
      description: "用于冲厕/拖地，避免浪费",
      co2Reduction: 60
    },
    {
      id: "water_08",
      category: "节水",
      categoryIcon: "💧",
      title: "及时修理漏水水龙头",
      description: "避免持续滴水，减少水资源浪费",
      co2Reduction: 30
    },
    {
      id: "water_09",
      category: "节水",
      categoryIcon: "🧺",
      title: "用洗衣水冲厕/拖地",
      description: "一水多用，提高水资源利用率",
      co2Reduction: 70
    },
    {
      id: "water_10",
      category: "节水",
      categoryIcon: "🌱",
      title: "清晨/傍晚浇花",
      description: "减少水分蒸发，提高浇水效率",
      co2Reduction: 20
    },

    // ========== 生活习惯类 (15个) ==========
    {
      id: "habit_01",
      category: "生活习惯",
      categoryIcon: "♻️",
      title: "分类投放生活垃圾",
      description: "提高资源回收率，减少填埋焚烧碳排放",
      co2Reduction: 60
    },
    {
      id: "habit_02",
      category: "生活习惯",
      categoryIcon: "🥢",
      title: "自带餐具，拒绝一次性餐具",
      description: "减少一次性木筷、塑料餐盒使用",
      co2Reduction: 70
    },
    {
      id: "habit_03",
      category: "生活习惯",
      categoryIcon: "📄",
      title: "纸张双面打印/书写",
      description: "减少纸张消耗，保护森林资源",
      co2Reduction: 40
    },
    {
      id: "habit_04",
      category: "生活习惯",
      categoryIcon: "🛍️",
      title: "自带购物袋，拒绝塑料袋",
      description: "1个塑料袋碳足迹约80g CO₂",
      co2Reduction: 80
    },
    {
      id: "habit_05",
      category: "生活习惯",
      categoryIcon: "📦",
      title: "快递箱重复利用",
      description: "替代新纸箱，减少造纸碳排放",
      co2Reduction: 50
    },
    {
      id: "habit_06",
      category: "生活习惯",
      categoryIcon: "♻️",
      title: "旧衣物捐赠/改造",
      description: "延长衣物生命周期，减少纺织业碳排放",
      co2Reduction: 120
    },
    {
      id: "habit_07",
      category: "生活习惯",
      categoryIcon: "📱",
      title: "手机壳/膜重复使用",
      description: "减少塑料配件生产和废弃",
      co2Reduction: 30
    },
    {
      id: "habit_08",
      category: "生活习惯",
      categoryIcon: "📚",
      title: "旧书交换/借阅",
      description: "减少新书印刷和运输碳排放",
      co2Reduction: 90
    },
    {
      id: "habit_09",
      category: "生活习惯",
      categoryIcon: "🧴",
      title: "用 refill 装补充洗护用品",
      description: "减少塑料瓶生产和废弃",
      co2Reduction: 60
    },
    {
      id: "habit_10",
      category: "生活习惯",
      categoryIcon: "🪑",
      title: "旧家具翻新/改造",
      description: "替代购买新家具，减少木材消耗",
      co2Reduction: 200
    },
    {
      id: "habit_11",
      category: "生活习惯",
      categoryIcon: "🧻",
      title: "使用手帕替代纸巾",
      description: "减少纸巾消耗，保护森林资源",
      co2Reduction: 40
    },
    {
      id: "habit_12",
      category: "生活习惯",
      categoryIcon: "♻️",
      title: "易拉罐/塑料瓶单独回收",
      description: "提高金属/塑料回收率，减少冶炼碳排放",
      co2Reduction: 70
    },
    {
      id: "habit_13",
      category: "生活习惯",
      categoryIcon: "📱",
      title: "延长手机使用年限（≥3年）",
      description: "减少电子垃圾和生产碳排放",
      co2Reduction: 350
    },
    {
      id: "habit_14",
      category: "生活习惯",
      categoryIcon: "🧹",
      title: "用扫帚替代吸尘器",
      description: "减少电力消耗，低碳清洁",
      co2Reduction: 50
    },
    {
      id: "habit_15",
      category: "生活习惯",
      categoryIcon: "🌬️",
      title: "开窗通风替代开空调",
      description: "利用自然风，节约电力",
      co2Reduction: 100
    },

    // ========== 消费类 (10个) ==========
    {
      id: "consume_01",
      category: "消费",
      categoryIcon: "🎁",
      title: "拒绝过度包装商品",
      description: "减少包装垃圾，降低生产处理碳排放",
      co2Reduction: 80
    },
    {
      id: "consume_02",
      category: "消费",
      categoryIcon: "👕",
      title: "选择二手衣物",
      description: "延长衣物生命周期，减少纺织业碳排放",
      co2Reduction: 200
    },
    {
      id: "consume_03",
      category: "消费",
      categoryIcon: "📚",
      title: "借阅/共享书籍",
      description: "减少纸张印刷和运输碳排放",
      co2Reduction: 120
    },
    {
      id: "consume_04",
      category: "消费",
      categoryIcon: "🎧",
      title: "维修电子设备替代换新",
      description: "延长电子产品寿命，减少电子垃圾",
      co2Reduction: 350
    },
    {
      id: "consume_05",
      category: "消费",
      categoryIcon: "🌱",
      title: "购买环保认证产品",
      description: "支持低碳生产方式，推动行业转型",
      co2Reduction: 150
    },
    {
      id: "consume_06",
      category: "消费",
      categoryIcon: "🚫",
      title: "减少1次非必要网购",
      description: "降低快递包装和物流运输碳排放",
      co2Reduction: 180
    },
    {
      id: "consume_07",
      category: "消费",
      categoryIcon: "👜",
      title: "买耐用款包袋",
      description: "避免频繁更换，减少皮革/布料消耗",
      co2Reduction: 160
    },
    {
      id: "consume_08",
      category: "消费",
      categoryIcon: "🍽️",
      title: "自带饭盒买熟食",
      description: "减少一次性餐盒使用",
      co2Reduction: 70
    },
    {
      id: "consume_09",
      category: "消费",
      categoryIcon: "🎮",
      title: "租游戏/会员替代买碟",
      description: "减少光盘和包装生产碳排放",
      co2Reduction: 90
    },
    {
      id: "consume_10",
      category: "消费",
      categoryIcon: "💄",
      title: "买大包装化妆品",
      description: "减少小包装塑料瓶数量",
      co2Reduction: 60
    },

    // ========== 办公类 (10个) ==========
    {
      id: "office_01",
      category: "办公",
      categoryIcon: "💻",
      title: "电子文档替代纸质打印",
      description: "减少纸张消耗，保护森林",
      co2Reduction: 50
    },
    {
      id: "office_02",
      category: "办公",
      categoryIcon: "📄",
      title: "废弃纸张背面再利用",
      description: "双面使用，减少纸张浪费",
      co2Reduction: 30
    },
    {
      id: "office_03",
      category: "办公",
      categoryIcon: "💡",
      title: "下班关闭办公室所有灯光",
      description: "避免空转耗电，节约电力",
      co2Reduction: 80
    },
    {
      id: "office_04",
      category: "办公",
      categoryIcon: "🔌",
      title: "下班关闭电脑/打印机",
      description: "避免待机耗电，节约能源",
      co2Reduction: 60
    },
    {
      id: "office_05",
      category: "办公",
      categoryIcon: "☕",
      title: "自带咖啡杯到公司",
      description: "减少一次性纸杯使用",
      co2Reduction: 40
    },
    {
      id: "office_06",
      category: "办公",
      categoryIcon: "📧",
      title: "用邮件/IM替代纸质 memo",
      description: "无纸化办公，减少纸张消耗",
      co2Reduction: 30
    },
    {
      id: "office_07",
      category: "办公",
      categoryIcon: "🪑",
      title: "下班整理桌面，关闭电源",
      description: "养成节能习惯，减少待机能耗",
      co2Reduction: 50
    },
    {
      id: "office_08",
      category: "办公",
      categoryIcon: "🌿",
      title: "办公室摆放绿植",
      description: "吸收CO₂，改善室内空气质量",
      co2Reduction: 20
    },
    {
      id: "office_09",
      category: "办公",
      categoryIcon: "📞",
      title: "用视频会议替代出差",
      description: "减少差旅行程碳排放",
      co2Reduction: 400
    },
    {
      id: "office_10",
      category: "办公",
      categoryIcon: "📦",
      title: "办公用品重复领用",
      description: "避免过度申领，减少资源浪费",
      co2Reduction: 40
    },

    // ========== 绿植/环保类 (10个) ==========
    {
      id: "plant_01",
      category: "绿植",
      categoryIcon: "🌱",
      title: "在家种植1盆绿植",
      description: "绿植吸收CO₂，释放氧气",
      co2Reduction: 30
    },
    {
      id: "plant_02",
      category: "绿植",
      categoryIcon: "🍂",
      title: "落叶堆肥做花肥",
      description: "减少垃圾清运，自制有机肥",
      co2Reduction: 50
    },
    {
      id: "plant_03",
      category: "绿植",
      categoryIcon: "🌳",
      title: "参与社区植树活动",
      description: "树木长期吸收CO₂，固碳环保",
      co2Reduction: 5000
    },
    {
      id: "plant_04",
      category: "绿植",
      categoryIcon: "🌱",
      title: "用厨余垃圾堆肥",
      description: "减少填埋，自制天然肥料",
      co2Reduction: 100
    },
    {
      id: "plant_05",
      category: "绿植",
      categoryIcon: "🌿",
      title: "阳台种香草/蔬菜",
      description: "减少购买运输，自给自足",
      co2Reduction: 120
    },
    {
      id: "plant_06",
      category: "环保",
      categoryIcon: "🚯",
      title: "外出随手捡垃圾",
      description: "维护环境，减少垃圾污染",
      co2Reduction: 20
    },
    {
      id: "plant_07",
      category: "环保",
      categoryIcon: "🐦",
      title: "悬挂人工鸟巢",
      description: "保护鸟类，维护生态平衡",
      co2Reduction: 10
    },
    {
      id: "plant_08",
      category: "环保",
      categoryIcon: "🌊",
      title: "参与河流清洁志愿活动",
      description: "保护水环境，减少污染",
      co2Reduction: 80
    },
    {
      id: "plant_09",
      category: "绿植",
      categoryIcon: "🌱",
      title: "用淘米水浇花",
      description: "一水多用，节约自来水",
      co2Reduction: 30
    },
    {
      id: "plant_10",
      category: "环保",
      categoryIcon: "📢",
      title: "向朋友分享1条低碳知识",
      description: "扩大环保影响力，推动集体减碳",
      co2Reduction: 10
    }
  ]
  private readonly tendTasksTableName: string = 'tendTasksTable'
  public tendTasksStore: relationalStore.RdbStore | undefined = undefined
  private DBManager: TendencyDBManager = TendencyDBManager.getInstance()

  private getRandomSixTasks(): string {
    const shuffled: CarbonTask[] = [...TendTasksTable.carbonTasks].sort(() => Math.random() - 0.5);
    const selectedTasks: CarbonTask[] = shuffled.slice(0, 6)

    const result: TaskMsgType[] = selectedTasks.map((task: CarbonTask): TaskMsgType => {
      const taskMsg: TaskMsgType = {
        taskItem: task,
        isFinished: false
      }
      return taskMsg
    })

    return JSON.stringify(result);
  }

  public static getInstance(): TendTasksTable {
    if (!TendTasksTable.instance) {
      TendTasksTable.instance = new TendTasksTable()
    }
    return TendTasksTable.instance
  }

  public async initTable() {
    if (this.DBManager.tendencyRdbStore === undefined) {
      TendTasksLogger.error('数据库创建失败')
      return
    }
    this.tendTasksStore = this.DBManager.tendencyRdbStore

    try {
      await this.tendTasksStore.execute(TendencySQL.createTasksSQL(this.tendTasksTableName))
      TendTasksLogger.info('表创建成功')
    } catch (error) {
      TendTasksLogger.error('表创建失败：' + error)
    }
  }

  public async deleteMyTable() {
    if (!this.tendTasksStore) {
      TendTasksLogger.error('数据库创建失败')
      return
    }
    try {
      await this.tendTasksStore.execute(TendencySQL.deleteTasksTableSQL(this.tendTasksTableName))
      TendTasksLogger.info('表删除成功')
    } catch (error) {
      TendTasksLogger.error('表删除失败：' + error)
    }
  }

  /**
   * 新建用户时初始化总数据 || 新的一天时初始化总数据
   * @param acc：账号
   * @param date：日期
   */
  public async setOriginalTotalData(acc: string, date: string) {
    if (!this.tendTasksStore) {
      TendTasksLogger.error('数据库创建失败')
      return
    }
    const tasks: string = this.getRandomSixTasks()
    const valueBucket: relationalStore.ValuesBucket = {
      account: acc,
      recordDate: date,
      tasksMsg: tasks
    }
    try {
      const rowId = await this.tendTasksStore.insert(this.tendTasksTableName, valueBucket)
      TendTasksLogger.info(acc + '初始化数据成功：' + `rowId:${rowId},tasks=${tasks}`)
    } catch (error) {
      TendTasksLogger.error(acc + '初始化数据失败：' + error)
    }
  }

  /**
   *用户登录时返回总数据，供给 UI 渲染页面
   * @param acc：账号
   * @param date：日期
   * @returns：返回总数据对象
   */
  public async getTodayTasksData(acc: string, date: string): Promise<TasksDataType> {
    let resultItem: TasksDataType = {
      id: -1,
      account: '',
      recordDate: '',
      tasksMsg: '[{"taskId":"travel_01","isFinished":false},{"taskId":"travel_02","isFinished":false},{"taskId":"travel_03","isFinished":false},{"taskId":"travel_04","isFinished":false},{"taskId":"travel_05","isFinished":false},{"taskId":"travel_06","isFinished":false}]'
    }

    return new Promise((resolve) => {
      if (!this.tendTasksStore) {
        TendTasksLogger.error('数据库创建失败')
        resolve(resultItem)
        return
      }
      const predicates2 = new relationalStore.RdbPredicates(this.tendTasksTableName)
      predicates2.equalTo('ACCOUNT', acc)

      this.tendTasksStore.query(predicates2,
        ['id', 'account', 'recordDate', 'tasksMsg'],
        (err: BusinessError, resultSet) => {
          if (err) {
            TendTasksLogger.error('查询失败1：' + `code is ${err.code},message is ${err.message}`)
            resultSet?.close()
            resolve(resultItem)
            return
          }

          let isExist = false

          try {
            while (resultSet.goToNextRow()) {
              const id = resultSet.getLong(resultSet.getColumnIndex('id'))
              const account = resultSet.getString(resultSet.getColumnIndex('account'))
              const recordDate = resultSet.getString(resultSet.getColumnIndex('recordDate'))
              const tasksMsg = resultSet.getString(resultSet.getColumnIndex('tasksMsg'))
              if (account === acc && recordDate === date) {
                resultItem.id = id
                resultItem.account = account
                resultItem.recordDate = recordDate
                resultItem.tasksMsg = tasksMsg
                TendTasksLogger.info('找到指定账户：' +
                  `id=${id}, account=${account}, recordDate=${recordDate}, tasksMsg=${tasksMsg}`)
                isExist = true
                break
              }
            }
          } catch (error) {
            TendTasksLogger.error('查询失败2：' + error)
            isExist = false
          } finally {
            resultSet.close()
          }
          if (isExist) {
            resolve(resultItem)
          } else {
            TendTasksLogger.info('未找到该用户，可以创建为新用户')
            resolve(resultItem)
          }
        })
    })
  }

  /**
   * 更新总数据
   * @param data：账号信息
   * @param date：日期
   */
  public updateTotalData(data: TasksDataType, date: string) {
    if (!this.tendTasksStore) {
      TendTasksLogger.error('数据库创建失败')
      return
    }
    const valueBucket2: relationalStore.ValuesBucket = {
      account: data.account,
      recordDate: data.recordDate,
      tasksMsg: data.tasksMsg
    }

    let predicates1 = new relationalStore.RdbPredicates(this.tendTasksTableName)
    predicates1.equalTo('account', data.account)
      .and()
      .equalTo('recordDate', date)

    this.tendTasksStore.update(valueBucket2, predicates1,
      (err: BusinessError, rows: number) => {
        if (err) {
          TendTasksLogger.error('更新失败: ' + `code is ${err.code},message is ${err.message}`)
        }
        TendTasksLogger.info('更新成功: ' + `rows:${rows};` +
          `id=${data.id}, account=${data.account}, recordDate=${data.recordDate}, tasksMsg=${data.tasksMsg}`)
      })
  }

  public async hasTodayItem(acc: string, date: string): Promise<boolean> {
    return new Promise((resolve) => {
      if (!this.tendTasksStore) {
        TendTasksLogger.error('数据库创建失败')
        resolve(false)
        return
      }
      const predicates2 = new relationalStore.RdbPredicates(this.tendTasksTableName)
      predicates2.equalTo('ACCOUNT', acc)

      this.tendTasksStore.query(predicates2,
        ['id', 'account', 'recordDate', 'tasksMsg'],
        (err: BusinessError, resultSet) => {
          if (err) {
            TendTasksLogger.error('查询失败1：' + `code is ${err.code},message is ${err.message}`)
            resultSet?.close()
            resolve(false)
            return
          }

          let isExist = false
          try {
            while (resultSet.goToNextRow()) {
              const id = resultSet.getLong(resultSet.getColumnIndex('id'))
              const account = resultSet.getString(resultSet.getColumnIndex('account'))
              const recordDate = resultSet.getString(resultSet.getColumnIndex('recordDate'))
              const tasksMsg = resultSet.getString(resultSet.getColumnIndex('tasksMsg'))
              if (account === acc && recordDate === date) {
                TendTasksLogger.info('找到指定账户：' +
                  `id=${id}, account=${account}, recordDate=${recordDate}, tasksMsg=${tasksMsg}`)
                isExist = true
                break
              }
            }
          } catch (error) {
            TendTasksLogger.error('查询失败2：' + error)
            isExist = false
          } finally {
            resultSet.close()
          }
          if (isExist) {
            resolve(true)
          } else {
            TendTasksLogger.info('未找到该用户，可以创建为新用户')
            resolve(false)
          }
        }
      )
    })
  }
}