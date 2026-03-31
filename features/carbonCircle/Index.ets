import { BuilderNameConstants } from '@ohos/customrouter'

export { carbonCircle_homePage } from './src/main/ets/pages/CarbonCircle_homePage'

export async function harInit(builderName: string): Promise<void> {
  switch (builderName) {
    case BuilderNameConstants.HAR_carboncircle_msgEditingPage:
      await import("./src//main//ets//pages//MsgEditPage")
      break
    default:
      break
  }
}