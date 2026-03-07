@Component
export struct gaugeComponent {

  @Builder
  descriptionBuilder() {
    Text('说明文本')
      .maxFontSize('30sp')
      .minFontSize('10.0vp')
      .fontColor('#fffa2a2d')
      .fontWeight(FontWeight.Medium)
      .width('100%')
      .height('100%')
      .textAlign(TextAlign.Center)
  }

  build() {
    Gauge({ value: 5, min: 1, max: 20 }) {
      Column() {
        Text('50')
          .fontWeight(FontWeight.Medium)
          .width('62%')
          .fontColor('#ff182431')
          .maxFontSize('60.0vp')
          .minFontSize('30.0vp')
          .textAlign(TextAlign.Center)
          .margin({ top: '35%' })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        // Text('辅助文本')
        //   .maxFontSize('16.0fp')
        //   .minFontSize('10.0vp')
        //   .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        //   .fontWeight(FontWeight.Regular)
        //   .width('67.4%')
        //   .height('9.5%')
        //   .textAlign(TextAlign.Center)
      }.width('100%').height('100%')
    }
    .startAngle(210)
    .endAngle(150)
    .width('90%')
    .height('75%')
    .strokeWidth(18)
    .trackShadow({ radius: 7, offsetX: 7, offsetY: 7 })
    // .description(this.descriptionBuilder)
    .colors([[new LinearGradient([{ color: '#deb6fb', offset: 0 }, { color: '#ac49f5', offset: 1 }]), 9],
      [new LinearGradient([{ color: '#bbb7fc', offset: 0 }, { color: '#564af7', offset: 1 }]), 8],
      [new LinearGradient([{ color: '#f5b5c2', offset: 0 }, { color: '#e64566', offset: 1 }]), 7],
      [new LinearGradient([{ color: '#f8c5a6', offset: 0 }, { color: '#ed6f21', offset: 1 }]), 6],
      [new LinearGradient([{ color: '#fceb99', offset: 0 }, { color: '#f7ce00', offset: 1 }]), 5],
      [new LinearGradient([{ color: '#dbefa5', offset: 0 }, { color: '#a5d61d', offset: 1 }]), 4],
      [new LinearGradient([{ color: '#c1e4be', offset: 0 }, { color: '#64bb5c', offset: 1 }]), 3],
      [new LinearGradient([{ color: '#c0ece5', offset: 0 }, { color: '#61cfbe', offset: 1 }]), 2],
      [new LinearGradient([{ color: '#b5e0f4', offset: 0 }, { color: '#46b1e3', offset: 1 }]), 1]])
  }
}