import { HTTPForLoginLogger } from "../Hilog/HilogInfo"
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { HTTPLogger } from '../Hilog/HilogInfo';
import { JSON } from '@kit.ArkTS';
import { loginExtraDataType, ReturnDataType } from "../Interface/HTTPForLoginType";

export class HTTPForLoginState {
  private static instance: HTTPForLoginState
  private readonly url: string = 'http://192.168.43.16:8081/api/v1/user/login'
  public extraData: loginExtraDataType = {
    account: '',
    password: '',
    device_id: ''
  }
  // public returnData: ReturnDataType = {
  //   code: 0,
  //   msg: '',
  //   dao: {
  //     UserID: 0,
  //     Username: '',
  //     access_token: '',
  //     expires_in: 0
  //   }
  // }
  public returnUserName: string = ''
  public returnJWT: string = ''
  public isOK: boolean = false

  public static getInstance(): HTTPForLoginState {
    if (!HTTPForLoginState.instance) {
      HTTPForLoginState.instance = new HTTPForLoginState()
    }
    return HTTPForLoginState.instance
  }

  public setExtraData(acc: string, psw: string, device_id: string) {
    this.extraData.account = acc
    this.extraData.password = psw
    this.extraData.device_id = device_id.trim()
  }

  public async HTTPFunc() {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForLoginLogger.error('HttpRequest对象创建失败')
    }

    httpRequest.request(
      this.url,
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: this.extraData
      }, (err: BusinessError, data: http.HttpResponse) => {
      if (err) {
        HTTPForLoginLogger.error('HttpRequest获取数据失败')
      }
      const msg = data.result as ReturnDataType | string
      const response: ReturnDataType = typeof msg === 'string' ? JSON.parse(msg) as ReturnDataType : msg
      if (response.code !== 0) {
        this.isOK = false
        return
      }
      HTTPForLoginLogger.info(`response: ${JSON.stringify(response)}`)
      HTTPForLoginLogger.info(`extraData: ${JSON.stringify(this.extraData)}`)
      this.returnUserName = response.dao.username
      this.returnJWT = response.dao.access_token
      this.isOK = true
      HTTPForLoginLogger.info(`response.dao.Username: ${JSON.stringify(response)}`)
      HTTPForLoginLogger.info(`response.dao.Username: ${JSON.stringify(this.returnUserName)}`)
      }
    )
  }
}