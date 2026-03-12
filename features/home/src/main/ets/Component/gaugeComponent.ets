@Component
export struct gaugeComponent {
  @State totalCarbonConsumption: number = 5

  build() {
    /**
     *  等级：模范 良好 基准 偏高 高碳
     *  颜色：059669 10B981 D97706 EA580C DC2626
     */
    Gauge({ value: this.totalCarbonConsumption, min: 1, max: 30 }) {
      Column() {
        Text(this.totalCarbonConsumption.toString())
          .fontWeight(FontWeight.Medium)
          .width('65%')
          .fontColor('#000000')
          .maxFontSize('60.0vp')
          .minFontSize('30.0vp')
          .textAlign(TextAlign.Center)
          .margin({ top: 30 })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .onClick(() => {
            this.totalCarbonConsumption += 1
          })
        Text('先锋')
          .maxFontSize('16.0fp')
          .minFontSize('10.0vp')
          .fontColor('#059669')
          .fontWeight(FontWeight.Regular)
          .width('67.4%')
          .height('9.5%')
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('100%')
    }
    .startAngle(210)
    .endAngle(150)
    .width('90%')
    .height('75%')
    .strokeWidth(18)
    .trackShadow({ radius: 7, offsetX: 7, offsetY: 7 })
    .colors([
      // 1. 低碳先锋（1-5 → 数值范围4 → 占比：4/29≈13.79% → 结束百分比13.79）
      [new LinearGradient([{ color: '#10B981', offset: 0 }, { color: '#059669', offset: 1 }]), 13.79],
      // 2. 低碳良好（5-8 → 数值范围3 → 占比：3/29≈10.34% → 累计24.13%）
      [new LinearGradient([{ color: '#34D399', offset: 0 }, { color: '#10B981', offset: 1 }]), 10.34],
      // 3. 基准水平（8-12 → 数值范围4 → 占比：4/29≈13.79% → 累计37.92%）
      [new LinearGradient([{ color: '#F59E0B', offset: 0 }, { color: '#D97706', offset: 1 }]), 13.79],
      // 4. 偏高排放（12-18 → 数值范围6 → 占比：6/29≈20.69% → 累计58.61%）
      [new LinearGradient([{ color: '#F97316', offset: 0 }, { color: '#EA580C', offset: 1 }]), 20.96],
      // 5. 高碳排放（18-30 → 数值范围12 → 占比：12/29≈41.38% → 累计100%）
      [new LinearGradient([{ color: '#EF4444', offset: 0 }, { color: '#DC2626', offset: 1 }]), 41.38]
    ])
  }
}