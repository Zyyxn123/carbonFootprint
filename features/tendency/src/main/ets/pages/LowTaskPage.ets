import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"

@Component
export struct lowTaskPage {
  build() {

  }
}


@Builder
export function harBuilder(value: object) {
  NavDestination() {
    lowTaskPage()
  }
  .title('lowTaskPage')
  .onBackPressed(() => {
    // (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    // AppStorage.set('CurrentIndex', 1)
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_tendency_lowTask
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}