import CarLevVM from "../ViewModel/CarLevelViewModel"

@Component
export struct gaugeComponent {

  showTotalCarEmiData() {
    if (CarLevVM.total_carbon > 50) {
      return 50
    } else {
      return CarLevVM.total_carbon
    }
  }

  build() {
    Column() {
      Gauge({ value: this.showTotalCarEmiData(), min: 0, max: 50 }) {
        Column() {
          Text(CarLevVM.total_carbon.toFixed(0))
            .fontWeight(FontWeight.Medium)
            .width('50%')
            .fontColor('#000')
            .fontSize(35)
            .textAlign(TextAlign.Center)
            .margin({ top: 25, bottom: 3 })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
          Text(CarLevVM.showConfig?.name)
            .maxFontSize('16.0fp')
            .minFontSize('10.0vp')
            .fontColor(CarLevVM.showConfig?.color)
            .fontWeight(FontWeight.Regular)
            .width('70%')
            .height('12%')
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
        // 1. 低碳先锋（0-12）
        [new LinearGradient([{ color: '#10B981', offset: 0 }, { color: '#059669', offset: 1 }]), 24],
        // 2. 低碳良好（12-20）
        [new LinearGradient([{ color: '#34D399', offset: 0 }, { color: '#10B981', offset: 1 }]), 16],
        // 3. 基准水平（20-28）
        [new LinearGradient([{ color: '#F59E0B', offset: 0 }, { color: '#D97706', offset: 1 }]), 16],
        // 4. 偏高排放（28-36）
        [new LinearGradient([{ color: '#F97316', offset: 0 }, { color: '#EA580C', offset: 1 }]), 16],
        // 5. 高碳排放（36-50）
        [new LinearGradient([{ color: '#EF4444', offset: 0 }, { color: '#DC2626', offset: 1 }]), 28]
      ])

      Text(CarLevVM.showConfig?.text)
        .fontColor(CarLevVM.showConfig?.color)
        .fontWeight(FontWeight.Regular)
        .width('90%')
        .height(45)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}