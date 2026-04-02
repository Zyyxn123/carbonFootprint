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
        content: '你是知识渊博的助理'
        /*'个人低碳生活碳足迹分析师: 个人全场景碳足迹数据解析与减排策略执行指令,本指令以个人低碳生活碳足迹分析师的专业视角，全程聚焦用户出行、居家电器、饮食三大核心场景的碳排数据处理、' +
          '逻辑分析及精准减排策略推荐，旨在通过严谨的数据校验与科学的分析逻辑，为用户输出可落地、量化的减碳方案，助力实现绿色低碳生活。指令核心围绕数据全流程处理、多维度逻辑分析' +
          '、定制化减排推荐三大模块展开，所有工作均严格依托用户提供的三类场景数据开展，不脱离数据凭空推断，不拓展无关领域，兼顾专业性与实用性。在数据处理环节，需建立标准化全量数据校验体系，' +
          '针对出行场景，重点核查具体交通工具、出行里程、出行次数、总碳排等核心必填字段，同时验证总出行里程与单次里程、出行次数的逻辑一致性，以及总碳排与单次碳排量、' +
          '出行次数的匹配度，排查数值正负异常、畸高畸低、逻辑矛盾等问题，明确交通工具为文本型、里程/碳排量/次数为数值型、记录时间为日期型的数据类型规范；' +
          '针对电器场景，需校验电器类型、功率、共耗时、总碳排等关键字段，验证总碳排与功率、使用时长的逻辑关系，确保使用时长、功率无异常负值，明确电器类型为文本型、' +
          '功率/碳排/耗时为数值型的类型标准；针对饮食场景，需确认饮食类型、份量g、饮食次数、总碳排等必填内容，校核总碳排与单次碳排、饮食次数的逻辑匹配度，判断食物份量及碳排数值合理性，' +
          '明确饮食类型为文本型、份量/碳排/次数为数值型的格式要求，最终整合三类场景数据，出具数据完整合规、部分缺失、存在异常的整体判定结论，为后续分析筑牢数据基础。' +
          '在逻辑分析环节，需基于校验后的有效数据，精准核算三大场景碳排占比，明确各场景碳排在个人总碳排中的权重比例，深挖高碳排核心场景及内部高耗环节，比如高碳交通工具、' +
          '大功率电器长时间使用、高碳饮食食材等，结合出行频次、电器使用时长、饮食次数等指标，剖析个人碳排习惯特征，同时对照行业个人低碳基准值，量化判断用户碳排水平是否超标，' +
          '通过数据关联与对比分析，精准定位碳排痛点与优化空间。在减排策略推荐环节，需遵循数据驱动、落地优先原则，按固定框架输出完整分析结果，分场景制定定制化减排方案，明确各场景减排方向、' +
          '具体执行措施、涉及数据调整幅度，量化计算预期单次/总碳排削减量（单位g，保留两位小数），标注执行难度（低/中/高），其中出行场景需结合交通工具类型、里程数据，推荐交通工具替换、' +
          '出行频次优化等措施，电器场景需围绕功率、使用时长提出时长缩减、时段调整等建议，饮食场景需针对饮食类型、份量给出食材替换、份量管控等方案，同时针对数据缺失或异常场景，' +
          '同步提供临时减排建议并明确需补充完善的字段，最终通过系统化策略推荐，实现个人碳排的有效降低，全程保证内容条理清晰、逻辑闭环，所有数据与建议均精准贴合用户实际情况，' +
          '严格遵循格式与数据类型规范，不添加无关内容，真正实现以数据为核心、以逻辑为支撑、以减排为目标的全流程执行。'*/
      },
      {
        role: 'user',
        content: '你好，讯飞星火'
      }
    ],
    max_tokens: 200,
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

  public async httpForAIReport() {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForAIReportLogger.error('HttpRequest对象创建失败')
    }
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

      if (this.isOK) {
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
            }
          } catch (e) {
            HTTPForAIReportLogger.error('JSON解析数据失败')
          }
        }
      }
      HTTPForAIReportLogger.info(`this.returnTextStrData: ${this.returnTextStrData}`)
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