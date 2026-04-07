import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { HTTPForDeepSeekLogger } from '../Hilog/HilogInfo';
import { aiReportExtraDataType } from '../Interface/HTTPForAIReportType';
import { buffer, JSON, util } from '@kit.ArkTS';
import { AiChatResponse } from '../Interface/HTTPForDeepSeekType';

export class HTTPForAI_deepSeek {
  private static instance: HTTPForAI_deepSeek
  private readonly url: string = 'https://api.deepseek.com/chat/completions'
  public extraData: aiReportExtraDataType = {
    model: 'deepseek-chat',
    messages: [
      {
        role: 'system',
        content: '你是知识渊博的助理'
      },
      {
        role: 'user',
        content: '你好，deepSeek'
      }
    ],
    // max_tokens: 2000,
    stream: true
  }
  public returnData: string = ''
  public isOK: boolean = false

  public static getInstance(): HTTPForAI_deepSeek {
    if (!HTTPForAI_deepSeek.instance) {
      HTTPForAI_deepSeek.instance = new HTTPForAI_deepSeek()
    }
    return HTTPForAI_deepSeek.instance
  }

  public async httpForAns(ques: string) {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForDeepSeekLogger.error('HttpRequest对象创建失败')
      return
    }
    this.extraData.messages[1].content = ques

    try {
      let res = new ArrayBuffer(0)
      // 订阅HTTP流式响应数据接收事件
      httpRequest.on('dataReceive', (data: ArrayBuffer) => {
        const newRes = new ArrayBuffer(res.byteLength + data.byteLength)
        const resView = new Uint8Array(newRes)
        resView.set(new Uint8Array(res))
        resView.set(new Uint8Array(data), res.byteLength)
        res = newRes

        let decoder = util.TextDecoder.create('utf-8')
        let str = decoder.decodeToString(new Uint8Array(data))
        HTTPForDeepSeekLogger.info(`res length: ${res.byteLength}`)
        HTTPForDeepSeekLogger.info(`str: ${str}`)

        const lines = str.split('\n').map(line => line.trim()).filter(line => line)

        for (const line of lines) {
          if (line.startsWith('data: ')) {
            const jsonStr: string = line.replace('data: ', '').trim()
            if (jsonStr === '[DONE]') {
              this.returnData += jsonStr
              HTTPForDeepSeekLogger.info('最终数据解析数据成功：' + this.returnData)
              this.isOK = true
              return
            }

            try {
              const response: AiChatResponse =
                typeof jsonStr === 'string'
                  ? JSON.parse(jsonStr) as AiChatResponse : jsonStr

              const content: string = response.choices[0].delta.content || ''
              if (content) {
                this.returnData += content
                HTTPForDeepSeekLogger.info('JSON解析数据成功：' + this.returnData)
              }
            } catch (e) {
              HTTPForDeepSeekLogger.error('JSON解析数据失败：', e)
            }
          }
        }
      })

      // 用于订阅HTTP流式响应数据接收完毕事件。
      httpRequest.on('dataEnd', () => {
        HTTPForDeepSeekLogger.info(`No more data in response, data receive end`)
      })

      // 订阅HTTP流式响应数据接收进度事件，下载服务器的数据时，可以通过该回调获取数据下载进度。
      httpRequest.on('dataReceiveProgress', (data: http.DataReceiveProgressInfo) => {
        HTTPForDeepSeekLogger.info(`dataReceiveProgress data:` + JSON.stringify(data))
        HTTPForDeepSeekLogger.info('dataReceiveProgress receiveSize:'
          + data.receiveSize + ', totalSize:' + data.totalSize)
      })

      // 订阅HTTP流式响应数据发送进度事件，向服务器上传数据时，可以通过该回调获取数据上传进度。
      httpRequest.on('dataSendProgress', (data: http.DataSendProgressInfo) => {
        HTTPForDeepSeekLogger.info(`dataSendProgress data:` + JSON.stringify(data))
        HTTPForDeepSeekLogger.info('dataSendProgress receiveSize:'
          + data.sendSize + ', totalSize:' + data.totalSize)
      })

      let streamInfo: http.HttpRequestOptions = {
        // 可选，默认为http.RequestMethod.GET，用于向服务器获取数据，而POST方法用于向服务器上传数据。
        method: http.RequestMethod.POST,
        // 开发者根据自身业务需要添加header字段。
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer sk-25daea1a4f1647afb3b3ed9e999f73de`
        },
        // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定。
        extraData: this.extraData, // 请求体内容
      }

      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。
      // 请求的参数可以在extraData中指定。
      httpRequest.requestInStream(this.url, streamInfo)
        .then((data: number) => {
          HTTPForDeepSeekLogger.info(`requestInStream OK!`)
          HTTPForDeepSeekLogger.info(`ResponseCode : ${JSON.stringify(data)}`)
          // 取消订阅步骤3中订阅的事件，并调用destroy方法主动销毁。
          this.destroyRequest(httpRequest)
        }).catch((err: Error) => {
        HTTPForDeepSeekLogger.error(`requestInStream ERROR : err = ${JSON.stringify(err)}`)
        // 取消订阅步骤3中订阅的事件，并调用destroy方法主动销毁。
        this.destroyRequest(httpRequest)
      })

    } catch (error) {
      HTTPForDeepSeekLogger.error(`err=${error}`)
    }
  }

  public destroyRequest(httpRequest: http.HttpRequest) {
    // 取消订阅HTTP流式响应数据接收事件。
    httpRequest.off('dataReceive');
    // 取消订阅HTTP流式响应数据发送进度事件。
    httpRequest.off('dataSendProgress');
    // 取消订阅HTTP流式响应数据接收进度事件。
    httpRequest.off('dataReceiveProgress');
    // 取消订阅HTTP流式响应数据接收完毕事件。
    httpRequest.off('dataEnd');
    // 当该请求使用完毕时，调用destroy方法主动销毁。
    httpRequest.destroy();
  }
}