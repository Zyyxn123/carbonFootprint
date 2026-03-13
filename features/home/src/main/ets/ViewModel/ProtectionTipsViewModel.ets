import { HealthNewsItem, HealthNewsResult, HealthyNewsPreference, HTTPForHealthyNews } from '@ohos/utils'

@ObservedV2
class ProtectionTipsViewModel {
  private HTTPIns = HTTPForHealthyNews.getInstance()
  private healthyNewsPre: HealthyNewsPreference = HealthyNewsPreference.getInstance()

  private httpForHN: HTTPForHealthyNews = HTTPForHealthyNews.getInstance()
  @Trace tipTitle: string = 'title'
  @Trace tipAuthor_name: string = 'author'
  @Trace dataVM: HealthNewsItem[] | undefined = undefined

  // async getInfo() {
  //   await this.HTTPIns.HTTPFunc()
  //   const param = this.HTTPIns.data
  //   if (!param) {
  //     this.data = JSON.parse(param) as HealthNewsItem
  //   }
  // }

  getTipMsg() {
    let myData = JSON.parse(this.healthyNewsPre.getTodayData_HN()) as HealthNewsItem[]
    this.dataVM = myData
    this.tipTitle = this.dataVM[0].title
    this.tipAuthor_name = this.dataVM[0].author_name
  }
}

export default new ProtectionTipsViewModel()