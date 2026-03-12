import { foodAndDrinkTypeModel } from "../Model/FoodAndDrinkModel"
import { transportsTypeModel } from "../Model/GreenTravelModel"
import { applicationsTypeModel } from "../Model/HouseApplicationModel"
import GreenTravelViewModel from "../ViewModel/GreenTravelViewModel"

@Component
export struct funcListsSelectedMap {
  @Prop funcList: transportsTypeModel[] | applicationsTypeModel[] | foodAndDrinkTypeModel[]
  @Prop title: string

  @Builder
  funcListBuilder(item: transportsTypeModel, index: number) {
    Column({ space: 5 }) {
      Row() {
        Image(item.img)
          .width(30)
          .fillColor(item.tsc)
      }
      .width(50)
      .height(50)
      .padding(10)
      .backgroundColor(item.bgc)
      .borderRadius(20)

      Text(item.ts)
        .fontColor('#000')
        .fontSize(14)
    }
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#000')
        .margin({ bottom: 20 })

      Grid() {
        ForEach(this.funcList, (item: transportsTypeModel, index: number) => {
          GridItem() {
            this.funcListBuilder(item, index)
          }
        })
      }
      .height(280)
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .columnsGap(15)
      .rowsGap(10)
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .padding(15)
    .width('92%')
    .height(340)
    .margin({ left: 15, right: 15, top: 15 })
    .borderRadius(20)
    .backgroundColor('#fffafafa')
    .border({ width: 1, color: '#ffeeeeee' })
  }
}