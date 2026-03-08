import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";

@Component
export struct environmentalTipPage {
  build() {
    Text('awwwdawdfaf')
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    environmentalTipPage()
  }
  .title('environmentalTipPage')
  .onBackPressed(() => {
    (AppStorage.get('entryHapRouter') as NavPathStack).replacePathByName('quickStart', null, false)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_environmentalTip
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}