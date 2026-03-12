import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";

@Component
export struct environmentalTipsPage {
  build() {
    Text('awwwdawdfaf')
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    environmentalTipsPage()
  }
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