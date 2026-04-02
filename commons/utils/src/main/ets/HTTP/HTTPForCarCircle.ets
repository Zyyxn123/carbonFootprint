import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { HTTPForCarCleLogger } from '../Hilog/HilogInfo';
import { JSON } from '@kit.ArkTS';
import { createExtraData } from '../Interface/HTTPForCarCiecleType';

export class HTTPForCarCircle {
  private static instance: HTTPForCarCircle
  private readonly publishUrl: string = 'http://192.168.43.16:8081/api/v1/posts/publish'
  public extraData: createExtraData = {
    title: '',
    content: '',
    images: [],
    avatar: ''
  }
  public returnData: undefined = undefined
  public JWT: string = ''

  public static getInstance(): HTTPForCarCircle {
    if (!HTTPForCarCircle.instance) {
      HTTPForCarCircle.instance = new HTTPForCarCircle()
    }
    return HTTPForCarCircle.instance
  }

  public setJWT(JWT: string) {
    this.JWT = JWT
  }

  public httpForPublishData(title: string, content: string, images: string[], avatar: string) {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForCarCleLogger.error('HttpRequest对象创建失败')
    }

    this.extraData = {
      title: title,
      content: content,
      images: images,
      avatar: avatar
    }

    HTTPForCarCleLogger.info('extraData:' + JSON.stringify(this.extraData))


    httpRequest.request(
      this.publishUrl,
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.JWT.trim()}`
        },
        extraData: JSON.stringify(this.extraData)
      }, (err: BusinessError, data: http.HttpResponse) => {
      if (err) {
        HTTPForCarCleLogger.error('HttpRequest获取数据失败 err: ' +
          `code=${err.code}, msg=${err.message}`)
        HTTPForCarCleLogger.error('HttpRequest获取数据失败 data: ' +
          `data=${JSON.stringify(data)}`)
      }
      let msg = data.result.toString()
      HTTPForCarCleLogger.info(`msg: ${JSON.stringify(msg)}`)
      HTTPForCarCleLogger.info(`data: ${JSON.stringify(data.result)}`)
    }
    )
  }
}