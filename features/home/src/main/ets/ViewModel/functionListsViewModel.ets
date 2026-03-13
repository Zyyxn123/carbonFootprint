import { BuilderNameConstants } from '@ohos/customrouter'
import { HealthNewsResult, HealthyNewsPreference, HTTPForHealthyNews } from '@ohos/utils'
import functionListsTypeModel from '../Model/functionListsModel'
import { JSON } from '@kit.ArkTS'

@ObservedV2
class functionListsViewModel {
  @Trace functionLists: functionListsTypeModel[] = [
    {
      image: '1',
      text: $r('app.string.functionLists_greenTravel'),
      url: ''
    },
    {
      image: '2',
      text: $r('app.string.functionLists_environmentalEncyclopedia'),
      url: ''
    },
    {
      image: $r('app.media.garbageIdentification'),
      text: $r('app.string.functionLists_garbageIdentification'),
      url: BuilderNameConstants.HAR_home_houseApplication
    },
    {
      image: $r('app.media.recycling'),
      text: $r('app.string.functionLists_recycling'),
      url: BuilderNameConstants.HAR_home_foodAndDrink
    },
  ]
}

export default new functionListsViewModel()