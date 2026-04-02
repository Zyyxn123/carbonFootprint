import { DataPanelMsgType } from "../Type/DataPanelMsgType"
import CarLevVM from "../ViewModel/CarLevelViewModel"

@Builder
function buildDataPanel(config: DataPanelConfiguration) {
  Column() {
    Column() {
      ForEach(config.values, (item: number, index: number) => {
        ChildItem({ item: item, index: index, max: config.maxValue })
      }, (item: number, index: number) => item.toString())
    }
    .padding(6)
  }
}

class DataPanelBuilder implements ContentModifier<DataPanelConfiguration> {
  constructor() {
  }

  applyContent(): WrappedBuilder<[DataPanelConfiguration]> {
    return wrapBuilder(buildDataPanel)
  }
}

@Component
export struct dataPanelComponent {
  @State vals: number[] = [CarLevVM.travel_carbon, CarLevVM.electric_carbon, CarLevVM.food_carbon]

  dynamicMax(): number {
    const max = Math.max(...CarLevVM.dataPanelVals)
    return max * 3
  }



  build() {
    Column() {
      Row() {
        DataPanel({ values: CarLevVM.dataPanelVals,
          max: this.dynamicMax(), type: DataPanelType.Circle })
          .width(290)
          .height(135)
          .constraintSize({ maxWidth: '100%' })
          .padding({ top: 5 })
          .contentModifier(new DataPanelBuilder())
      }
      .borderRadius(15)
      .backgroundColor('#fff')
      .border({ width: 1, color: '#37800f'})
      .onClick(() => {
        this.vals = [CarLevVM.travel_carbon += 1, CarLevVM.electric_carbon += 2, CarLevVM.food_carbon]
      })

      // 最大值和类型显示
      Row() {
        Text(`最高: ${CarLevVM.dataPanelMsg.maxValue.toFixed(2)}`)
          .fontSize(16)
          .fontColor('#000')
          .fontWeight(FontWeight.Medium)
          .margin({ right: 8 })

        Text(`(${CarLevVM.dataPanelMsg.type})`)
          .fontSize(16)
          .fontColor('#000')
      }
      .margin({ top: 15 })
      .justifyContent(FlexAlign.Center)
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct ChildItem {
  @Prop item: number;
  @Prop index: number;
  @Prop max: number;
  public color1: string = '#65ff00dd'
  public color2: string = '#37800f'
  public color3: string = '#65ffe600'
  public color4: string = '#6595ff00'
  public colorArray: Array<string> = [this.color2, this.color1, this.color4]

  build() {
    RelativeContainer() {
      Row() {
        Rect()
          .height(25)
          .width(this.item * 335 / this.max)
          .foregroundColor((this.index < 0 || this.index >= this.colorArray.length) ? this.colorArray[0] :
            this.colorArray[this.index])
          .radius(5)
          .align(Alignment.Start)
        Text(' ' + this.item)
          .fontSize(15)
          .fontColor(Color.Black)
      }
      .margin({ right: 5})
    }.height(28)
  }
}