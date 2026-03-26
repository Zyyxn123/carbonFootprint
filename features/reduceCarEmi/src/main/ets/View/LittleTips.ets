import { redEmiRecType } from "../Model/LittleTipsModel"
import tipsVM from "../ViewModel/LittleTipsViewModel"

@Extend(Text)
function titleStyles() {
  .fontSize(18)
  .fontColor('#000')
  .fontWeight(FontWeight.Medium)
}

@Extend(Span)
function content1Styles() {
  .fontColor('#000')
  .fontSize(16)
  .fontWeight(FontWeight.Medium)
}

@Extend(Span)
function content2Styles() {
  .fontColor('#ff3c3c3c')
  .fontSize(16)
}

@Component
export struct LittleTips {
  @Builder
  imgAndTitleBuilder(index: number) {
    if (index === 0) {
      Row({ space: 5 }) {
        Image($r('app.media.redEmi_trans'))
          .width(25)

        Text('出行场景')
          .titleStyles()
      }
      .margin({ left: 10 })
    } else if (index === 1) {
      Row({ space: 5 }) {
        Image($r('app.media.reEmi_appliance'))
          .width(25)

        Text('电器场景')
          .titleStyles()
      }
      .margin({ left: 10 })
    } else if (index === 2) {
      Row({ space: 5 }) {
        Image($r('app.media.reEmi_food'))
          .width(25)

        Text('饮食场景')
          .titleStyles()
      }
      .margin({ left: 10 })
    }
  }

  @Builder
  displaySceneBuilder(item: redEmiRecType, index: number) {
    Divider()
      .vertical(false)
      .color('#ccc')
      .margin({ top: 10, bottom: 10 })
    this.imgAndTitleBuilder(index)

    Text() {
      Span('推荐举措：')
        .content1Styles()
      Span(item.recMeasure)
        .content2Styles()
    }
    .width('90%')
    .margin({ left: 25, top: 5 })

    Text() {
      Span('减排效果： ')
        .content1Styles()
      Span(item.emiRedEffect)
        .content2Styles()
    }
    .width('90%')
    .margin({ left: 25, top: 5 })

    Text() {
      Span('适配建议： ')
        .content1Styles()
      Span(item.adaptOffer)
        .content2Styles()
    }
    .width('90%')
    .margin({ left: 25, top: 5 })
  }

  build() {
    Column() {
      Column() {
        Text('分场景减排推荐方案')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontSize(20)
          .fontWeight(600)
          .fontColor('#000')

        ForEach(tipsVM.displayArray, (item: redEmiRecType, index: number) => {
          this.displaySceneBuilder(item, index)
        })
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .borderRadius(15)
      .backgroundColor('#fff')
      .border({ width: { top: 2 }, color: '#ccc' })
      .padding({ bottom: 10, top: 10 })
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .backgroundColor('#fff6f6f6')
    .borderRadius({ bottomLeft: 25, bottomRight: 25 })
    .border({ width: { bottom: 2 }, color: '#ccc'})
    .padding({ left: 10, right: 10, top: 10, bottom: 10 })
  }
}