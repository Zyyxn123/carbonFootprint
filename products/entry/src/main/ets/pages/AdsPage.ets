import AdsViewModel from '../ViewModel/AdsViewModel'
import AdsTypeModel from '../Model/AdsModel'
import { AdsItemView } from '../View/AdsItemView'
import { BuilderNameConstants, RouterModule, RouterNameConstants } from '@ohos/customrouter'

@Component
export struct AdsPage {
  @StorageLink('entryHapRouter') entryHapRouter: NavPathStack = new NavPathStack()
  private swiperCtrl: SwiperController = new SwiperController()
  private currAdsIndex: number = 0

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Swiper(this.swiperCtrl) {
          ForEach(AdsViewModel.adsList, (item: AdsTypeModel, index: number) => {
            AdsItemView({ item: item, index: index })
          }, (index: number) => {
            return index.toString()
          })
        }
        .loop(false)
        .autoPlay(false)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .effectMode(EdgeEffect.None)
        .indicator(new DotIndicator()
          .selectedItemWidth(25)
          .color($r('app.color.launch_ads_routerBar'))
          .selectedColor($r('app.color.launch_ads_routerBar_selected'))
        )

        Button($r('app.string.launch_ads_skipButton'))
          .margin({
            top: 15,
            right: 20
          })
          .fontSize(12)
          .width('15%')
          .height('4%')
          .backgroundColor($r('app.color.launch_ads_skipButton_background'))
          .fontColor($r('app.color.launch_ads_skipButton_word'))
          .onClick(() => {
            if (this.currAdsIndex <= 1 && this.currAdsIndex >= 0) {
              this.currAdsIndex += 1
              this.swiperCtrl.changeIndex(this.currAdsIndex, true)
            } else {
              this.entryHapRouter.replacePathByName('LogOrResPage', null, false)
            }
          })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.launch_ads_background'))
    }
    .hideTitleBar(true)
    .onBackPressed(() => true)
  }
}