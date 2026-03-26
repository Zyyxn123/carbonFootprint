import { LevConfigType } from "../ViewModel/DataSumViewModel";

class MyProgressModifier implements ContentModifier<ProgressConfiguration> {
  color: ResourceColor = Color.White;

  constructor(color: ResourceColor) {
    this.color = color;
  }

  applyContent(): WrappedBuilder<[ProgressConfiguration]> {
    return wrapBuilder(myProgress);
  }
}

@Builder
function myProgress(config: ProgressConfiguration) {
  Grid() {
    GridItem() {
      Path()
        .commands('M27 0 L35.25 17.5 L54.5 19.575 L40.5 32.75 L43.75 51.25 L27 42.5 L10.3 51.25 L13.75 32.75 L0.25 19.5 L18.75 17 L27 0 Z')
        .fill(config.enabled && config.value >= 1 ? (config.contentModifier as MyProgressModifier).color :
          Color.White)
        .stroke('#37800f')
        .strokeWidth(1)
    }   .alignSelf(ItemAlign.Center)

    GridItem() {
      Path()
        .commands('M27 0 L35.25 17.5 L54.5 19.575 L40.5 32.75 L43.75 51.25 L27 42.5 L10.3 51.25 L13.75 32.75 L0.25 19.5 L18.75 17 L27 0 Z')
        .fill(config.enabled && config.value >= 2 ? (config.contentModifier as MyProgressModifier).color :
          Color.White)
        .stroke('#37800f')
        .strokeWidth(1)
    }   .alignSelf(ItemAlign.Center)

    GridItem() {
      Path()
        .commands('M27 0 L35.25 17.5 L54.5 19.575 L40.5 32.75 L43.75 51.25 L27 42.5 L10.3 51.25 L13.75 32.75 L0.25 19.5 L18.75 17 L27 0 Z')
        .fill(config.enabled && config.value >= 3 ? (config.contentModifier as MyProgressModifier).color :
          Color.White)
        .stroke('#37800f')
        .strokeWidth(1)
    }   .alignSelf(ItemAlign.Center)

    GridItem() {
      Path()
        .commands('M27 0 L35.25 17.5 L54.5 19.575 L40.5 32.75 L43.75 51.25 L27 42.5 L10.3 51.25 L13.75 32.75 L0.25 19.5 L18.75 17 L27 0 Z')
        .fill(config.enabled && config.value >= 4 ? (config.contentModifier as MyProgressModifier).color :
          Color.White)
        .stroke('#37800f')
        .strokeWidth(1)
    }   .alignSelf(ItemAlign.Center)

    GridItem() {
      Path()
        .commands('M27 0 L35.25 17.5 L54.5 19.575 L40.5 32.75 L43.75 51.25 L27 42.5 L10.3 51.25 L13.75 32.75 L0.25 19.5 L18.75 17 L27 0 Z')
        .fill(config.enabled && config.value >= 5 ? (config.contentModifier as MyProgressModifier).color :
          Color.White)
        .stroke('#37800f')
        .strokeWidth(1)
    }
    .alignSelf(ItemAlign.Center)
  }
  .columnsTemplate('1fr 1fr 1fr')
  .rowsTemplate('1fr 1fr')
}

@Component
export struct LevelProgress {
  @Prop data: LevConfigType = {
    min: 0,
    max: 12,
    name: "低碳先锋",
    color: "#059669",
    level: 5
  }
  modifier = new MyProgressModifier('#37800f')
  @State myModifier: (MyProgressModifier | undefined) = this.modifier
  @State currentValue: number = this.data.level
  build() {
    Column() {
      Progress({ value: this.currentValue, total: 5, type: ProgressType.Ring })
        .contentModifier(this.modifier)
    }
    .width('65%')
    .height('80%')
  }
}