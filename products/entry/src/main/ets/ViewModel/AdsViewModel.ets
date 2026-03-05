import AdsTypeModel from '../Model/AdsModel'

@ObservedV2
class AdsViewModel {
  @Trace adsList: AdsTypeModel[] = [
    {
      image: $r('app.media.launchPage'),
        word: '从绿途开始,\n' + '        记录你的绿色足迹'
    },
    {
      image: $r('app.media.ads_first'),
      word: '环保小贴士,\n' + '        随手学知识'
    },
    {
      image: $r('app.media.ads_second'),
      word: '一键记录碳足迹,\n' + '        环保有迹可循',
      buttonWord: '立即体验'
    }
  ]
}

export default new AdsViewModel()