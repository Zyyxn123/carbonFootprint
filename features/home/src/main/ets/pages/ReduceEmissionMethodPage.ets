import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";

@Component
export struct reduceEmissionMethodPage {
  build() {

  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    reduceEmissionMethodPage()
  }
  .title('reduceEmissionMethodPage')
  .onBackPressed(() => {
    (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_reduceCarbonEmissionMethod
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}