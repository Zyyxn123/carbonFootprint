import { BuilderNameConstants } from '@ohos/customrouter';

// 给定 builderName 时
// 做动态 import，用于把页面代码加载到运行时（模块内部会注册 builder）
export async function harInit(builderName: string): Promise<void> {
  // 动态引入要跳转的页面
  switch (builderName) {
    case BuilderNameConstants.HAR_quickStart_qsPage:
      await import("./src/main/ets/pages/qsPage");
      break;
    case BuilderNameConstants.HARA_A2:
      // await import("./src/main/ets/components/mainpage/A2");
      break;
    default:
      break;
  }
}