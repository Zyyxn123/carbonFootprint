import { HealthNewsItem, HealthNewsResult, HealthyNewsPreference, HTTPForHealthyNews } from '@ohos/utils'

@ObservedV2
class ProtectionTipsViewModel {
  private HTTPIns = HTTPForHealthyNews.getInstance()
  private healthyNewsPre: HealthyNewsPreference = HealthyNewsPreference.getInstance()

  private httpForHN: HTTPForHealthyNews = HTTPForHealthyNews.getInstance()
  @Trace dataList: HealthNewsItem[] | undefined = undefined
  @Trace tipTitle: string = 'title'
  @Trace tipAuthor_name: string = 'author'
  @Trace tipUri: string = ''
  @Trace dataVM: HealthNewsItem[] | undefined = undefined

  getTipMsg() {
    let myData = JSON.parse(this.healthyNewsPre.getTodayData_HN()) as HealthNewsItem[]
    this.dataList = myData
    this.dataVM = myData
    this.tipTitle = this.dataVM[1].title
    this.tipAuthor_name = this.dataVM[1].author_name
    this.tipUri = this.dataVM[1].url
  }
}

export default new ProtectionTipsViewModel()