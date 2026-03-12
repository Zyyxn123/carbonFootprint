import { foodAndDrinkCardsDataTypeModel, foodAndDrinkPopBoxDataTypeModel } from "../Model/FoodAndDrinkModel"
import { cardsDataTypeModel, popBoxDataTypeModel } from "../Model/GreenTravelModel"
import { applicationsCardsDataTypeModel, applicationsPopBoxDataTypeModel } from "../Model/HouseApplicationModel"

@Component
export struct funcListsCards {
  @State arrow_towards: number = 180
  @State myBorderRadius: number = 20
  @State appear_bol: boolean = false
  @Prop cardsDataList: cardsDataTypeModel[] | applicationsCardsDataTypeModel[] | foodAndDrinkCardsDataTypeModel[]
  @Prop popBoxDataList: popBoxDataTypeModel[] | applicationsPopBoxDataTypeModel[] | foodAndDrinkPopBoxDataTypeModel[]
  private effect: object = TransitionEffect.asymmetric(
    TransitionEffect.OPACITY.animation({
      duration: 500,
      curve: Curve.EaseOut,
      playMode: PlayMode.Normal
    }),
    TransitionEffect.OPACITY
      .combine(TransitionEffect.translate({ x: 0, y: -160 }).animation({
        duration: 700,
        curve: Curve.EaseOut,
        playMode: PlayMode.Normal
      })))

  @Builder
  cardsBuilder() {
    Column() {
      Text(this.cardsDataList[0].num.toString() + this.cardsDataList[0]!.unit)
        .fontColor('#000')
        .fontSize(25)

      Text(this.cardsDataList[0].text)
        .fontColor('#000')
        .fontSize(15)
        .margin({ bottom: 15, top: 3 })

      Row({ space: 6 }) {
        Image(this.cardsDataList[2]!.img)
          .fillColor('#37800f')
          .width(20)

        Text(this.cardsDataList[2].text + '  '
          + this.cardsDataList[2].num.toString()
          + this.cardsDataList[2]!.unit)
          .fontColor('#000')
          .fontSize(17)
      }
    }
    .alignItems(HorizontalAlign.Start)

    Divider()
      .vertical(true)
      .color('#ccc')
      .width(40)
      .strokeWidth(1)

    Column() {
      Text(this.cardsDataList[1].num.toString() + this.cardsDataList[1]!.unit)
        .fontColor('#000')
        .fontSize(25)
        .margin({ bottom: 5 })

      Text(this.cardsDataList[1].text)
        .fontColor('#000')
        .fontSize(15)
        .margin({ bottom: 15, top: 3 })

      Progress({ value: 76, total: 100, type: ProgressType.Linear })
        .width(130)
        .backgroundColor('#000')
        .color('#81B29A')
        .border({ width: 1, color: '#000', radius: 5 })
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  popBoxBuilder() {
    Grid() {
      ForEach(this.popBoxDataList,
        (item: popBoxDataTypeModel, index: number) => {
          GridItem() {
            Column() {
              Text(item.num.toString() + item?.unit)
                .fontColor('#81B29A')
                .fontSize(25)
                .margin({ bottom: 5 })

              Text(item.text)
                .fontColor('#000')
                .fontSize(15)
            }
          }
        })
    }
    .height(140)
    .columnsTemplate('1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .columnsGap(30)
    .rowsGap(15)
  }

  build() {
    Column() {
      Column({ space: 15 }) {
        Row({ space: 5 }) {
          this.cardsBuilder()
        }
        .height(120)
        .width('100%')

        Image($r('app.media.arrow_up'))
          .width(20)
          .rotate({ angle: this.arrow_towards })
          .fillColor('#000')
          .onClick(() => {
            if (this.arrow_towards === 180) {
              this.arrow_towards = 0
              this.appear_bol = true
              this.myBorderRadius = 0
            } else {
              this.arrow_towards = 180
              this.appear_bol = false
              this.myBorderRadius = 20
            }
          })
          .animation({
            duration: 500,
            curve: Curve.EaseOut,
            playMode: PlayMode.Normal
          })
      }
      .justifyContent(FlexAlign.Center)
      .padding(12)
      .width('92%')
      .height(200)
      .margin({ left: 15, right: 15, top: 15 })
      .backgroundColor('#81B29A')
      .borderRadius({
        bottomLeft: this.myBorderRadius,
        bottomRight: this.myBorderRadius,
        topLeft: 20,
        topRight: 20
      })
      .animation({
        duration: 200,
        curve: Curve.EaseOut,
        playMode: PlayMode.Normal
      })

      if (this.appear_bol) {
        Column() {
          this.popBoxBuilder()
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('92%')
        .height(170)
        .backgroundColor('#fffafafa')
        .padding({
          left: 20,
          right: 20,
          top: 15,
          bottom: 15
        })
        .borderRadius({
          bottomLeft: 20,
          bottomRight: 20
        })
        .transition(this.effect)
        .border({ width: { left: 1, right: 1, bottom: 1 }, color: '#cccccc' })
      }
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }
}