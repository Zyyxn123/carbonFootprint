import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from '@ohos/customrouter'
import functionListsTypeModel from '../Model/functionListsModel'
import functionListsViewModel from '../ViewModel/functionListsViewModel'
import ProtectionTipsViewModel from '../ViewModel/ProtectionTipsViewModel'

@Component
export struct functionListsView {

  aboutToAppear(): void {
    if (ProtectionTipsViewModel.tipUri === '') {
      ProtectionTipsViewModel.getTipMsg()
    }
  }

  @Builder
  funcListItem(item: functionListsTypeModel, index: number) {
    Column({ space: 10 }) {
      if (item.image === '1') {
        Row() {
          Image($r('app.media.func_greenOut'))
            .width(35)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width(45)
        .backgroundColor($r('app.color.functionListsView_out_background'))
        .height(45)
        .borderRadius(22.5)
        .onClick(() => {
          buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_home_greenTravel)
        })
      } else if (item.image === '2') {
        Row() {
          Image($r('app.media.func_book'))
            .width(26)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width(45)
        .backgroundColor($r('app.color.functionListsView_tips_background'))
        .height(45)
        .borderRadius(22.5)
        .onClick(() => {
          buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_home_environmentalTips, new Object({
            dataList: ProtectionTipsViewModel.dataList
          }))
        })
      } else {
        Image(item.image)
          .width(45)
          .onClick(() => {
            buildRouterModel(RouterNameConstants.ENTRY_HAP, item.url)
          })
      }

      Text(item.text)
        .fontColor(Color.Black)
        .fontSize(13)
        .fontWeight(600)
    }
  }

  build() {
    Row() {
      ForEach(functionListsViewModel.functionLists,
        (item: functionListsTypeModel, index: number) => {
          this.funcListItem(item, index)
        })
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .width('100%')
    .padding({ left: 10, right: 10 })
  }
}