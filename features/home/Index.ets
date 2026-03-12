import { BuilderNameConstants } from '@ohos/customrouter'

export async function harInit(builderName: string): Promise<void> {
  switch (builderName) {
    case BuilderNameConstants.HAR_home_environmentalTip:
      await import("./src//main//ets//pages//EnvironmentalTipPage")
      break
    case BuilderNameConstants.HAR_home_greenTravel:
      await import("./src//main//ets//pages//GreenTravelPage")
      break
    case BuilderNameConstants.HAR_home_environmentalTips:
      await import("./src//main//ets//pages//EnvironmentalTipsPage")
      break
    case BuilderNameConstants.HAR_home_houseApplication:
      await import("./src//main//ets//pages//HouseApplicationPage")
      break
    case BuilderNameConstants.HAR_home_foodAndDrink:
      await import("./src//main//ets//pages//FoodAndDrinkPage")
      break
    case BuilderNameConstants.HAR_home_detailCarbonEmission:
      await import("./src//main//ets//pages//DetailEmissionPage")
      break
    case BuilderNameConstants.HAR_home_reduceCarbonEmissionMethod:
      await import("./src//main//ets//pages//ReduceEmissionMethodPage")
      break
    default:
      break
  }
}

export { home_mainPage } from './src/main/ets/pages/Home_mainPage'