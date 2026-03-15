import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import EnvironmentalTipsViewModel from "../ViewModel/ProtectionTipsViewModel";
import { JSON } from "@kit.ArkTS";
import { HealthNewsItem } from "@ohos/utils";

@Component
export struct environmentalTipsPage {
  @State pageTitle: ResourceStr = $r('app.string.functionLists_environmentalEncyclopedia')
  @Prop val: object

  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      ForEach((JSON.parse(JSON.stringify(this.val)) as type).dataList,
        (item: HealthNewsItem, index: number) => {
        // ToDo: 组件复用的知识点运用
        Column()
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor('#fff')
    // .linearGradient({
    //   direction: GradientDirection.Bottom,
    //   repeating: false,
    //   colors: [['#e7fdff', 0],
    //     ['#edffdd', 1]]
    // })
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    environmentalTipsPage({ val: value})
  }
  .hideTitleBar(true)
  .title('environmentalTipsPage')
  .onBackPressed(() => {
    (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_environmentalTips
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}

interface type {
  dataList: HealthNewsItem[]
}
