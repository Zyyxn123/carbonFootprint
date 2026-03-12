@Builder
function buildDataPanel(config: DataPanelConfiguration) {
  Column() {
    Column() {
      ForEach(config.values, (item: number, index: number) => {
        ChildItem({ item: item, index: index, max: config.maxValue })
      }, (item: number, index: number) => item.toString())
    }.padding(6)
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
  build() {
    Column() {
      Row() {
        DataPanel({ values: [12.3, 21.1, 13.4, 35.2], max: 160, type: DataPanelType.Circle })
          .width(280)
          .height(130)
          .constraintSize({ maxWidth: '100%' })
          .padding({ top: 5 })
          .contentModifier(new DataPanelBuilder())
      }
      .margin({ left: 5, right: 5, bottom: 5 })
      .borderRadius(15)
      .backgroundColor('#fff5f5f5')
    }
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
  public colorArray: Array<string> = [this.color2, this.color3, this.color1, this.color4]

  build() {
    RelativeContainer() {
      Row() {
        Rect()
          .height(18)
          .width(this.item * 400 / this.max)
          .foregroundColor((this.index < 0 || this.index >= this.colorArray.length) ? this.colorArray[0] :
            this.colorArray[this.index])
          .radius(5)
          .align(Alignment.Start)
        Text(' ' + this.item)
          .fontSize(15)
      }
    }.height(28)
  }
}