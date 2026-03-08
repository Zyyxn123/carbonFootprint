import { BuilderNameConstants } from '@ohos/customrouter'

export async function harInit(builderName: string): Promise<void> {
  switch (builderName) {
    case BuilderNameConstants.HAR_home_environmentalTip:
      await import("./src//main//ets//pages//EnvironmentalTipPage")
      break
    default:
      break
  }
}

export { home_mainPage } from './src/main/ets/pages/Home_mainPage'