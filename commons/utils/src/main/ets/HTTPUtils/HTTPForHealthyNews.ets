import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { HTTPLogger } from '../Hilog/HilogInfo';
import { JSON } from '@kit.ArkTS';
// import { HealthNewsResponse, HealthNewsResult } from '../Interface/HealthyNewsInterface';

export class HTTPForHealthyNews {
  private static instance: HTTPForHealthyNews
  private readonly parameter: string = 'key=ea411249b95ceeff42350003db9b7bb4' +
    '&page=1' +
    '&page_size=30' +
    '&is_filter=1' +
    '&type=jiankang'
  public data: string = ''

  public static getInstance(): HTTPForHealthyNews {
    if (!HTTPForHealthyNews.instance) {
      HTTPForHealthyNews.instance = new HTTPForHealthyNews()
    }
    return HTTPForHealthyNews.instance
  }

  async HTTPFunc() {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPLogger.error('HttpRequest对象创建失败')
    }

    httpRequest.request(
      'http://v.juhe.cn/toutiao/index?' + this.parameter,
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      }, (err: BusinessError, data: http.HttpResponse) => {
      if (!err) {
        HTTPLogger.info(`Result: ${JSON.stringify(data.result)}`)
        let msg: HealthNewsResponse = JSON.parse(data.result.toString()) as HealthNewsResponse
        HTTPLogger.info(`code: ${msg}`)
        HTTPLogger.info(`reason: ${msg.reason}`)
        HTTPLogger.info(`error_code: ${msg.error_code}`)
        HTTPLogger.info(`stat: ${msg.result.stat}`)
        HTTPLogger.info(`page: ${msg.result.page}`)
        HTTPLogger.info(`pageSize: ${msg.result.pageSize}`)
        HTTPLogger.info(`data: ${JSON.stringify(msg.result.data)}`)
        this.data = JSON.stringify(msg.result.data)
        httpRequest.destroy()
      } else {
        HTTPLogger.error(`error: ${JSON.stringify(err)}`)
        httpRequest.destroy()
        this.data = ''
      }
    })
  }
}

export interface HealthNewsResponse {
  reason: string;
  result: HealthNewsResult;
  error_code: number;
}

interface HealthNewsResult {
  stat: string;
  data: HealthNewsItem[];
  page: string;
  pageSize: string;
}

interface HealthNewsItem {
  uniquekey: string;
  title: string;
  date: string;
  category: string;
  author_name: string;
  url: string;
  thumbnail_pic_s?: string;
  thumbnail_pic_s02?: string;
  thumbnail_pic_s03?: string;
  is_content: string;
}

