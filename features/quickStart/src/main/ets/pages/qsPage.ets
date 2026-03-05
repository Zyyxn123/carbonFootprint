import { BuilderNameConstants, buildRouterModel, RouterModule, RouterNameConstants, } from '@ohos/customrouter';


@Component
struct qsPage {
  build() {
    Button('awfhuawhfiawhsfiu')
  }
}


// 定义页面 UI 并通过 RouterModule.registerBuilder
// (builderName, wrapBuilder(harBuilder)) 将 builder 注册到 RouterModule
@Builder
export function harBuilder(value: object) {
  NavDestination() {
    qsPage()
  }
  .hideTitleBar(true)
  .title('A1Page')
  .onBackPressed(() => {
    // RouterModule.pop(RouterNameConstants.ENTRY_HAP);
    return true;
  })
}

const builderName = BuilderNameConstants.HAR_quickStart_qsPage;
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder);
  RouterModule.registerBuilder(builderName, builder);
}
