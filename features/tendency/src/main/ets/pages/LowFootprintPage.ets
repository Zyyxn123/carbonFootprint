import { BuilderNameConstants, RouterModule } from "@ohos/customrouter"

@Component
export struct lowFootprintPage {
  build() {

  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    lowFootprintPage()
  }
  .title('lowFootprintPage')
  .onBackPressed(() => {
    (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    AppStorage.set('CurrentIndex', 1)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_tendency_lowFootprint
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}