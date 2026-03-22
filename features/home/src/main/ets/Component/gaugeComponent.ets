@Component
export struct gaugeComponent {
  @State totalCarbonConsumption: number = 5

  build() {
    Column() {
      /**
       *  等级：模范 良好 基准 偏高 高碳
       *  颜色：059669 10B981 D97706 EA580C DC2626
       */
      Gauge({ value: this.totalCarbonConsumption, min: 1, max: 99 }) {
        Column() {
          Text(this.totalCarbonConsumption.toString())
            .fontWeight(FontWeight.Medium)
            .width('50%')
            .fontColor('#000000')
            .maxFontSize('60.0vp')
            .minFontSize('30.0vp')
            .textAlign(TextAlign.Center)
            .margin({ top: 25 })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
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
      .height('76%')
      .strokeWidth(15)
      .trackShadow({ radius: 7, offsetX: 7, offsetY: 7 })
      .margin({ left: 10 })
      .colors([
        // 1. 低碳先锋（1-15） 占比 14.14%
        [new LinearGradient([{ color: '#10B981', offset: 0 }, { color: '#059669', offset: 1 }]), 14.14],
        // 2. 低碳良好（15-25） 占比 10.10%
        [new LinearGradient([{ color: '#34D399', offset: 0 }, { color: '#10B981', offset: 1 }]), 10.10],
        // 3. 基准水平（25-35） 占比 10.10%
        [new LinearGradient([{ color: '#F59E0B', offset: 0 }, { color: '#D97706', offset: 1 }]), 10.10],
        // 4. 偏高排放（35-45） 占比 10.10%
        [new LinearGradient([{ color: '#F97316', offset: 0 }, { color: '#EA580C', offset: 1 }]), 10.10],
        // 5. 高碳排放（45-100） 占比 55.56%
        [new LinearGradient([{ color: '#EF4444', offset: 0 }, { color: '#DC2626', offset: 1 }]), 55.56]
      ])

      Text('先锋')
        .fontColor('#059669')
        .fontWeight(FontWeight.Regular)
        .width('90%')
        .height(45)
        .backgroundColor(Color.Blue)
        .textAlign(TextAlign.Center)
    }
  }
}