import { BuilderNameConstants } from '@ohos/customrouter'

export async function harInit(builderName: string): Promise<void> {
  switch (builderName) {
    case BuilderNameConstants.HAR_quickStart_qsPage:
      await import("./src/main/ets/pages/Tendency_homePage")
      break
    case BuilderNameConstants.HAR_tendency_lowFootprint:
      await import("./src/main/ets/pages/LowFootprintPage")
      break
    case BuilderNameConstants.HAR_tendency_lowTask:
      await import("./src/main/ets/pages/LowTaskPage")
      break
    case BuilderNameConstants.HAR_tendency_tomorrowTendency:
      await import("./src/main/ets/pages/TomorrowTendencyPage")
      break
    default:
      break
  }
}

export { tendency_homePage } from './src/main/ets/pages/Tendency_homePage'