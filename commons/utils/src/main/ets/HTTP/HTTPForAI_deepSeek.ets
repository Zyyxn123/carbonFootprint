import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { HTTPForDeepSeekLogger } from '../Hilog/HilogInfo';
import { JSON } from '@kit.ArkTS';
import { loginExtraDataType, ReturnDataType } from "../Interface/HTTPForLoginType";
import { HTTPForDeepSeekType } from '../Interface/HTTPForDeepSeekType';


export class HTTPForAI_deepSeek {
  private static instance: HTTPForAI_deepSeek
  private readonly url: string = 'https://api.deepseek.com/chat/completions'

  public static getInstance(): HTTPForAI_deepSeek {
    if (!HTTPForAI_deepSeek.instance) {
      HTTPForAI_deepSeek.instance = new HTTPForAI_deepSeek()
    }
    return HTTPForAI_deepSeek.instance
  }

  public async httpForAns() {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForDeepSeekLogger.error('HttpRequest对象创建失败')
    }

    try {
      const res = await httpRequest.request(
        this.url,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          }
        })

      if (res.responseCode !== 200) {
        HTTPForDeepSeekLogger.error('request失败:' + `responseCode=${res.responseCode}, resultType=${res.resultType}`)
        return
      }

      const msg = res.result as string | HTTPForDeepSeekType
      HTTPForDeepSeekLogger.info(`msg=${msg}`)

      const response: HTTPForDeepSeekType =
        typeof msg === 'string' ? JSON.parse(msg) as HTTPForDeepSeekType : msg

      if (response.code !== 0) {
        HTTPForDeepSeekLogger.error(`request失败: request.code=${response.code}, response.msg=${response.msg}`)
        return
      }
      HTTPForDeepSeekLogger.info(`response=${response}`)

    } catch (error) {
      HTTPForDeepSeekLogger.error(`err=${error}`)
      return
    }
  }
}