import functionListsTypeModel from '../Model/functionListsModel'

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
      url: ''
    },
    {
      image: $r('app.media.recycling'),
      text: $r('app.string.functionLists_recycling'),
      url: ''
    },
  ]
}

export default new functionListsViewModel()