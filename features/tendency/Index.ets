import { BuilderNameConstants } from '@ohos/customrouter'

export async function harInit(builderName: string): Promise<void> {
  switch (builderName) {
    case BuilderNameConstants.HAR_quickStart_qsPage:
      await import("./src/main/ets/pages/Tendency_homePage")
      break
    default:
      break
  }
}

export { tendency_homePage } from './src/main/ets/pages/Tendency_homePage'