import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { backButton } from "../Component/BackButton"
import { reduceEmiTarget } from "../View/ReduceEmiTarget"
import { toDoTasksList } from "../View/ToDoTasksList"

@Component
export struct lowTaskPage {
  @State bol: boolean = false

  build() {
    Column() {
      backButton({ pageTitle: '碳挑战', bol: this.bol })

      List({ space: 10 }) {
        reduceEmiTarget()

        toDoTasksList()

        ListItem() {}
        .width('100%')
        .height(100)
      }
      .padding({ left: 10, right: 10 })
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .width('100%')
    }
    .width('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor('#edffdd')
    .linearGradient({
      direction: GradientDirection.Bottom,
      repeating: false,
      colors: [['#e7fdff', 0],
        ['#edffdd', 1]]
    })
  }
}


@Builder
export function harBuilder(value: object) {
  NavDestination() {
    lowTaskPage()
  }
  .hideTitleBar(true)
  .title('lowTaskPage')
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_tendency_lowTask
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}