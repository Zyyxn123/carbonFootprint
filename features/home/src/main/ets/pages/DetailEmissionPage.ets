import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";

@Component
export struct detailEmissionPage {
  build() {
    Column() {
      backButton({ pageTitle: '碳规则与项目介绍' })

      Scroll() {
        Column({ space: 4 }) {
          // 一、项目概述
          Text('一、项目概述')
            .fontSize(22)
            .fontColor('#1a5fb4')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })

          Text('碳足迹计算APP是一款基于HarmonyOS生态开发的个人碳排放量化与管理系统。应用旨在帮助用户追踪日常生活各领域的碳排放量，通过数据可视化呈现碳足迹分布，并提供科学的减排建议，助力用户培养低碳生活习惯，共同应对气候变化挑战。')
            .fontSize(16)
            .fontColor('#000')
            .textAlign(TextAlign.Start)
            .margin({ left: 16, right: 16 })

          // 二、核心功能模块
          Text('二、核心功能模块')
            .fontSize(22)
            .fontColor('#1a5fb4')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })

          Text('1. 交通出行碳排放计算')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 支持汽车、公交、地铁、步行、骑行等多种交通工具\n• 根据行驶距离和交通工具类型自动计算二氧化碳排放量\n• 周度/月度碳排放趋势分析图表')
            .fontSize(16).fontColor('#000')
            .textAlign(TextAlign.Start)
            .margin({ left: 32, right: 16 })

          Text('2. 家居生活碳排放计算')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 家庭能源消耗（电力、燃气、水资源）记录与换算\n• 家用电器使用时长与能效等级关联计算\n• 住宅供暖/制冷能耗评估')
            .fontSize(16)
            .textAlign(TextAlign.Start).fontColor('#000')
            .margin({ left: 32, right: 16 })

          Text('3. 饮食消费碳排放计算')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 常见食品类别的碳足迹数据库\n• 餐饮消费记录与碳排放关联分析\n• 本地食材与进口食材的碳排放差异对比')
            .fontSize(16).fontColor('#000')
            .textAlign(TextAlign.Start)
            .margin({ left: 32, right: 16 })

          Text('4. 环保知识与减排建议')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 实时环保资讯推送\n• 个性化减排行动建议\n• 碳积分与成就激励体系')
            .fontSize(16)
            .textAlign(TextAlign.Start).fontColor('#000')
            .margin({ left: 32, right: 16 })

          Text('5. 数据可视化与报告')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 多维度碳排放数据图表展示（柱状图、折线图、饼图、雷达图）\n• 碳足迹分布热力图\n• 定期生成碳排放报告与改进建议')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .margin({ left: 32, right: 16 }).fontColor('#000')

          // 三、碳排放计算原理与方法（带数据示例）
          Text('三、碳排放计算原理与方法')
            .fontSize(22)
            .fontColor('#1a5fb4')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })

          Text('本应用采用国际通用的碳排放计算标准，结合中国本土化排放因子数据库：')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .margin({ left: 16, right: 16 }).fontColor('#000')

          Text('1. 交通领域计算公式')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('碳排放量 = 行驶里程 × 排放因子')
            .fontSize(16)
            .fontColor('#c01c28')
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .margin({ left: 32, right: 16 })

          Text('示例数据（每公里碳排放量）：')
            .fontSize(16)
            .fontColor('#2e3436')
            .margin({ left: 32, top: 8, right: 16 })

          Text('• 小型汽油车：0.18 kg CO₂/km\n• 中型汽油车：0.24 kg CO₂/km\n• 纯电动车（电网平均）：0.12 kg CO₂/km\n• 公交车：0.08 kg CO₂/km\n• 地铁：0.05 kg CO₂/km\n• 自行车/步行：0 kg CO₂/km')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .margin({ left: 48, right: 16 }).fontColor('#000')

          Text('2. 家居能源计算公式')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('电力碳排放 = 用电量(kWh) × 电网排放因子(kgCO₂/kWh)')
            .fontSize(16)
            .fontColor('#c01c28')
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .margin({ left: 32, right: 16 })

          Text('燃气碳排放 = 用气量(m³) × 燃气排放因子(kgCO₂/m³)')
            .fontSize(16)
            .fontColor('#c01c28')
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .margin({ left: 32, right: 16 })

          Text('示例数据：')
            .fontSize(16)
            .fontColor('#2e3436')
            .margin({ left: 32, top: 8, right: 16 })

          Text('• 中国电网平均排放因子：0.581 kg CO₂/kWh\n• 天然气排放因子：2.16 kg CO₂/m³\n• 居民生活用水：0.34 kg CO₂/m³')
            .fontSize(16).fontColor('#000')
            .textAlign(TextAlign.Start)
            .margin({ left: 48, right: 16 })

          Text('3. 饮食消费计算公式')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('食品碳排放 = 消费量(kg) × 生命周期排放因子(kgCO₂/kg)')
            .fontSize(16)
            .fontColor('#c01c28')
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .margin({ left: 32, right: 16 })

          Text('示例数据（每公斤食物碳排放）：')
            .fontSize(16)
            .fontColor('#2e3436')
            .margin({ left: 32, top: 8, right: 16 })

          Text('• 牛肉：27 kg CO₂/kg\n• 猪肉：12 kg CO₂/kg\n• 鸡肉：7 kg CO₂/kg\n• 大米：2.5 kg CO₂/kg\n• 蔬菜：0.5 kg CO₂/kg\n• 水果：1.2 kg CO₂/kg')
            .fontSize(16)
            .textAlign(TextAlign.Start).fontColor('#000')
            .margin({ left: 48, right: 16 })

          // 四、数据管理与隐私保护
          Text('四、数据管理与隐私保护')
            .fontSize(22)
            .fontColor('#1a5fb4')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })

          Text('1. 本地化数据存储')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 用户个人数据优先存储在设备本地\n• 采用加密存储技术保护敏感信息\n• 支持数据备份与跨设备同步（用户授权后）')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .margin({ left: 32, right: 16 }).fontColor('#000')

          Text('2. 隐私保护机制')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 最小化数据收集原则\n• 匿名化数据处理\n• 明确的用户数据使用授权流程')
            .fontSize(16)
            .textAlign(TextAlign.Start).fontColor('#000')
            .margin({ left: 32, right: 16 })

          // 五、减排行动与社会价值
          Text('五、减排行动与社会价值')
            .fontSize(22)
            .fontColor('#1a5fb4')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })

          Text('1. 个人减排贡献量化')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 将减排行动转化为可量化的碳减排量\n• 个人碳账户与社会碳减排目标关联')
            .fontSize(16)
            .textAlign(TextAlign.Start).fontColor('#000')
            .margin({ left: 32, right: 16 })

          Text('2. 社区互动与知识共享')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 低碳生活方式经验分享\n• 节能减排挑战活动\n• 环保志愿者社区')
            .fontSize(16)
            .textAlign(TextAlign.Start).fontColor('#000')
            .margin({ left: 32, right: 16 })

          // 六、未来发展方向
          Text('六、未来发展方向')
            .fontSize(22)
            .fontColor('#1a5fb4')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })

          Text('1. AI智能分析与预测')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 基于用户历史数据的碳排放模式识别\n• 个性化减排路径优化建议\n• 碳足迹未来趋势预测')
            .fontSize(16)
            .textAlign(TextAlign.Start).fontColor('#000')
            .margin({ left: 32, right: 16 })

          Text('2. 物联网设备集成')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 智能电表、水表数据自动采集\n• 智能家居设备能耗监控\n• 新能源汽车充电数据对接')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .margin({ left: 32, right: 16 }).fontColor('#000')

          Text('3. 碳金融与生态建设')
            .fontSize(18)
            .fontColor('#2e3436')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, top: 10 })

          Text('• 个人碳资产管理与交易\n• 绿色消费积分兑换体系\n• 碳中和项目众筹参与平台')
            .fontSize(16)
            .textAlign(TextAlign.Start).fontColor('#000')
            .margin({ left: 32, right: 16 })

          // 七、免责声明
          Text('七、免责声明')
            .fontSize(22)
            .fontColor('#1a5fb4')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })

          Text('本应用所有碳排放计算均基于公开科学数据和标准化方法学，计算结果仅供参考。实际减排效果受多种因素影响，建议结合专业机构指导制定减排计划。\n\n数据来源：\n• 中国道路交通排放因子数据库\n• IPCC排放因子清单\n• 中国电力企业联合会统计数据\n• 联合国粮农组织(FAO)食品碳排放数据')
            .fontSize(16)
            .fontColor('#555753')
            .textAlign(TextAlign.Start)
            .margin({ left: 16, right: 16, bottom: 40 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .width('100%')
      .layoutWeight(1)

      Column() {}
      .height(20)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .background('#fff')
    .padding({ left: 5, right: 5 })
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    detailEmissionPage()
  }
  .hideTitleBar(true)
  .title('detailEmissionPage')
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_detailCarbonEmission
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}