import { BuilderNameConstants } from '@ohos/customrouter';

export { ReduceEmiPage } from './src/main/ets/pages/ReduceEmiPage';


export async function harInit(builderName: string): Promise<void> {
  switch (builderName) {
    case BuilderNameConstants.HAR_reducecaremi_aiReportPage:
      await import("./src/main/ets/pages/AIReportPage")
      break
    default:
      break
  }
}