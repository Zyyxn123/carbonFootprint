import { HTTPForAIReportLogger } from "../Hilog/HilogInfo"
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { buffer, JSON, util } from '@kit.ArkTS';
import { aiReportExtraDataType, SparkStreamResponse, } from "../Interface/HTTPForAIReportType";


export class HTTPForAIReport {
  private static instance: HTTPForAIReport
  private readonly url: string = 'https://spark-api-open.xf-yun.com/v1/chat/completions'
  private readonly APIPsw: string = 'YiEjnvTfIbBzdGMPSUjL:GaJAShAEZhOsYWbXqRCK'
  public extraData: aiReportExtraDataType = {
    model: 'pro',
    messages: [
      {
        role: 'system',
        content:
        '个人低碳生活碳足迹分析师：基于用户在出行、居家用电、饮食三大核心场景的真实生活数据，进行专业碳排核算、现状分析与减排策略制定。'
      },
      {
        role: 'user',
        content: '请根据我的现有信息和指令给我一个减排方案报告(具体数字内容参考我的msg 字段后的具体数据，不要用符号代替，也可以参考国际，中国的网上的数据)' +
          '分析过程严格遵循现实碳排放因子与国内居民生活基准水平，输出内容客观、可量化、可落地，所有结论均基于真实生活逻辑与权威核算标准。' +
          '在数据解析阶段，基于用户提供的真实行为数据，准确核算各场景碳排放量，明确出行、家电、饮食在个人总碳足迹中的结构占比，对照国内城镇居民人均生活碳排放基准，' +
          '判断用户当前碳排水平处于偏高、正常或偏低区间，并识别高碳排核心来源，如高频高碳出行、大功率电器长期待机、高碳排放饮食结构等。' +
          '在现状分析阶段，结合用户实际使用频次、时长、里程、份量等行为特征，还原真实生活碳排放逻辑，客观说明高碳排行为的现实影响，' +
          '包括环境影响、资源消耗水平及与低碳生活标准的差距，做到有据可依、贴合日常。' +
          '在减排方案阶段，基于现实可行性给出分场景优化措施，每项措施均包含具体执行方式、预期减碳量（单位：g，保留两位小数）、执行难度分级（低/中/高），确保方案可直接应用于日常生活。' +
          '对于数据不足或记录不完整的情况，基于同类人群平均水平给出合理参考方案，并明确建议补充的数据项，以便后续更精准分析。' +
          '最终输出结构清晰、数据完整、现实依据充分，形成从碳排现状—问题定位—科学减排—效果预估的完整专业分析报告。' +
          '最终完整可行报告限制在3600字以内, 切记切记'
      }
    ],
    max_tokens: 4000,
    stream: true
  }
  public returnData: SparkStreamResponse[] = []
  public isOK: boolean = true
  public returnTextStrData: string = ''

  public static getInstance(): HTTPForAIReport {
    if (!HTTPForAIReport.instance) {
      HTTPForAIReport.instance = new HTTPForAIReport()
    }
    return HTTPForAIReport.instance
  }

  public setExtraData(userContent: string) {
    this.extraData.messages[1].content = userContent
  }

  public async httpForAIReport(msg: string) {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForAIReportLogger.error('HttpRequest对象创建失败')
    }

    this.extraData.messages[1].content += ('msg: ' + msg)
    HTTPForAIReportLogger.info(`msg: ${msg}`)

    this.returnData = []
    this.returnTextStrData = ''
    this.isOK = true

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
      HTTPForAIReportLogger.info(`res length: ${res.byteLength}`)
      HTTPForAIReportLogger.info(`str: ${str}`)

        if (str.startsWith('data: ')) {
          const jsonStr: string = str.replace('data: ', '').trim()
          if (jsonStr === '[DONE]') {
            this.returnTextStrData += jsonStr
          }

          try {
            const response: SparkStreamResponse =
              typeof jsonStr === 'string'
                ? JSON.parse(jsonStr) as SparkStreamResponse : jsonStr
            if (response.code !== 0) {
              this.isOK = false
              return
            }

            this.returnData.push(response)

            const content: string = response.choices[0].delta.content || ''
            if (content) {
              this.returnTextStrData += content
              HTTPForAIReportLogger.info(`this.returnTextStrData: ${this.returnTextStrData}`)
            }
          } catch (e) {
            HTTPForAIReportLogger.error('JSON解析数据失败')
          }
        }

    })

    // 用于订阅HTTP流式响应数据接收完毕事件。
    httpRequest.on('dataEnd', () => {
      HTTPForAIReportLogger.info(`No more data in response, data receive end`)
    })

    // 订阅HTTP流式响应数据接收进度事件，下载服务器的数据时，可以通过该回调获取数据下载进度。
    httpRequest.on('dataReceiveProgress', (data: http.DataReceiveProgressInfo) => {
      HTTPForAIReportLogger.info(`dataReceiveProgress data:` + JSON.stringify(data))
      HTTPForAIReportLogger.info('dataReceiveProgress receiveSize:'
        + data.receiveSize + ', totalSize:' + data.totalSize)
    })

    // 订阅HTTP流式响应数据发送进度事件，向服务器上传数据时，可以通过该回调获取数据上传进度。
    httpRequest.on('dataSendProgress', (data: http.DataSendProgressInfo) => {
      HTTPForAIReportLogger.info(`dataSendProgress data:` + JSON.stringify(data))
      HTTPForAIReportLogger.info('dataSendProgress receiveSize:'
        + data.sendSize + ', totalSize:' + data.totalSize)
    })

    let streamInfo: http.HttpRequestOptions = {
      // 可选，默认为http.RequestMethod.GET，用于向服务器获取数据，而POST方法用于向服务器上传数据。
      method: http.RequestMethod.POST,
      // 开发者根据自身业务需要添加header字段。
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.APIPsw.trim()}`
      },
      // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定。
      extraData: this.extraData, // 请求体内容
      readTimeout: 60000 * 6,
      connectTimeout: 60000 * 3
    }

    // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。
    // 请求的参数可以在extraData中指定。
    httpRequest.requestInStream(this.url, streamInfo)
      .then((data: number) => {
        HTTPForAIReportLogger.info(`requestInStream OK!`)
        HTTPForAIReportLogger.info(`ResponseCode : ${JSON.stringify(data)}`)
        this.isOK = false
        // 取消订阅步骤3中订阅的事件，并调用destroy方法主动销毁。
        this.destroyRequest(httpRequest)
      }).catch((err: Error) => {
      HTTPForAIReportLogger.error(`requestInStream ERROR : err = ${JSON.stringify(err)}`)
      // 取消订阅步骤3中订阅的事件，并调用destroy方法主动销毁。
      this.destroyRequest(httpRequest)
    })
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