import TabMenusTYpeModel from "../Model/TabMenusModel"

@ObservedV2
class TabMenusViewModel {
  @Trace TabsMenu: TabMenusTYpeModel[] = [
    {
      text: $r("app.string.custom_tab_home"),
      image: $r("app.media.tab_mainPage"),
      selectImage: $r("app.media.tab_mainPage_selected")
    },
    {
      text: $r("app.string.custom_tab_tendency"),
      image: $r("app.media.tab_carbonFootprint"),
      selectImage: $r("app.media.tab_carbonFootprint_selected")
    },
    {
      text: $r("app.string.custom_tab_carbonFriendCircle"),
      image: $r("app.media.tab_activity"),
      selectImage: $r("app.media.tab_activity_selected")
    },
    {
      text: $r("app.string.custom_tab_mine"),
      image: $r("app.media.tab_mine"),
      selectImage: $r("app.media.tab_mine_selected")
    }
  ]
}

export default new TabMenusViewModel()