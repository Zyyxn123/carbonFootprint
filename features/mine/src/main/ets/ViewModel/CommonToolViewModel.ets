import { commonToolTypeModel } from "../Model/CommonToolModel"

@ObservedV2
class CommonToolViewModel {
  @Trace toolsList: commonToolTypeModel[] = [
    {
      img: $r('app.media.mine_tools_attention'),
      content: $r('app.string.mine_tools_attention_content'),
      uri: '',
      darkModeColor: $r('app.color.toolsList_darkModeColor'),
      lightModeColor: $r('app.color.toolsList_lightModeColor')
    },
    {
      img: $r('app.media.mine_tools_fans'),
      content: $r('app.string.mine_tools_fans_content'),
      uri: '',
      darkModeColor: $r('app.color.toolsList_darkModeColor'),
      lightModeColor: $r('app.color.toolsList_lightModeColor')
    },
    {
      img: $r('app.media.mine_tools_medal'),
      content: $r('app.string.mine_tools_medal_content'),
      uri: '',
      darkModeColor: $r('app.color.toolsList_darkModeColor'),
      lightModeColor: $r('app.color.toolsList_lightModeColor')
    },
    {
      img: $r('app.media.mine_tools_help'),
      content: $r('app.string.mine_tools_help_content'),
      uri: '',
      darkModeColor: $r('app.color.toolsList_darkModeColor'),
      lightModeColor: $r('app.color.toolsList_lightModeColor')
    },
    {
      img: $r('app.media.mine_tools_settings'),
      content: $r('app.string.mine_tools_settings_content'),
      uri: '',
      darkModeColor: $r('app.color.toolsList_darkModeColor'),
      lightModeColor: $r('app.color.toolsList_lightModeColor')
    }
  ]
}

export default new CommonToolViewModel()