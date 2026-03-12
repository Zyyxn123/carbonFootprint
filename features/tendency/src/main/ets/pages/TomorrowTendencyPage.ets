import { BuilderNameConstants, RouterModule } from "@ohos/customrouter"

@Component
export struct tomorrowTendencyPage {
  build() {

  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    tomorrowTendencyPage()
  }
  .title('tomorrowTendencyPage')
  .onBackPressed(() => {
    (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    AppStorage.set('CurrentIndex', 1)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_tendency_tomorrowTendency
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}