import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { HTTPForCarCleLogger } from '../Hilog/HilogInfo';
import { JSON } from '@kit.ArkTS';
import {
  createExtraCommentType,
  createExtraDataType,
  innerComment_dataType,
  postDataType,
  returnCommentType,
  returnPostInnerCommentListType,
  returnPostListType,
  returnPostTopCommentListType,
  returnPraiseStateType,
  topComment_dataType
} from '../Interface/HTTPForCarCiecleType';

export class HTTPForCarCircle {
  private static instance: HTTPForCarCircle
  private readonly publishUrl: string = 'http://192.168.43.16:8081/api/v1/posts/publish'
  private readonly publishCommentUrl: string = 'http://192.168.43.16:8081/api/v1/posts/:'
  private readonly getPostListUrl: string = 'http://192.168.43.16:8081/api/v1/posts'
  private readonly getPostTopCommentUrl: string = 'http://192.168.43.16:8081/api/v1/posts/:'
  private readonly getPostInnerCommentUrl: string = 'http://192.168.43.16:8081/api/v1/comments/:'
  private readonly praiseCommentUrl: string = 'http://192.168.43.16:8081/api/v1/comments/:'
  private readonly praisePostUrl: string = 'http://192.168.43.16:8081/api/v1/posts/:'
  private readonly favoriteCommentUrl: string = 'http://192.168.43.16:8081/api/v1/posts/:'
  public extraData: createExtraDataType = {
    title: '',
    content: '',
    images: [],
    avatar: ''
  }
  public returnData: postDataType | undefined = undefined
  public JWT: string = ''
  public isOK: boolean = false

  public static getInstance(): HTTPForCarCircle {
    if (!HTTPForCarCircle.instance) {
      HTTPForCarCircle.instance = new HTTPForCarCircle()
    }
    return HTTPForCarCircle.instance
  }

  public setJWT(JWT: string) {
    this.JWT = JWT
  }

  public async httpForPublishData(data: createExtraDataType) {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForCarCleLogger.error('HttpRequest对象创建失败')
    }

    this.extraData = data

    HTTPForCarCleLogger.info('extraData:' + JSON.stringify(this.extraData) +
      `JWT=${this.JWT}`)

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
        HTTPForCarCleLogger.error(`HttpRequest获取数据失败 err:code=${err.code}, msg=${err.message}`)
        this.isOK = false
        return
      }
      // const msg = data.result as returnPostType | string
      // const response: returnPostType =
      //   typeof msg === 'string' ? JSON.parse(msg) as returnPostType : msg
      //
      // if (response.code !== 0) {
      //   this.isOK = false
      //   return
      // }
      //
      // this.returnData = response.data
      // HTTPForCarCleLogger.info(`response: ${JSON.stringify(response)}`)
      // HTTPForCarCleLogger.info(`response: ${response.code}`)
      // HTTPForCarCleLogger.info(`response: ${JSON.stringify(response.data)}`)
    }
    )
  }

  public async httpForPublishComment(id: number, data: createExtraCommentType) {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForCarCleLogger.error('HttpRequest对象创建失败')
    }

    const extraData = data

    HTTPForCarCleLogger.info('extraData:' + JSON.stringify(this.extraData) +
      `JWT=${this.JWT}`)

    try {
      const res = await httpRequest.request(
        this.publishCommentUrl + id + '/comments',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.JWT.trim()}`
          },
          extraData: JSON.stringify(extraData)
        })

      if (res.responseCode !== 200) {
        HTTPForCarCleLogger.error('request失败:' + `responseCode=${res.responseCode}, resultType=${res.resultType}`)
        return
      }

      const msg = res.result as string | returnCommentType
      HTTPForCarCleLogger.info(`msg=${msg}`)

      const response: returnCommentType =
        typeof msg === 'string' ? JSON.parse(msg) as returnCommentType : msg

      if (response.code !== 0) {
        HTTPForCarCleLogger.error(`request失败: request.code=${response.code}, response.msg=${response.msg}`)
        return
      }
      HTTPForCarCleLogger.info(`response=${response}`)
    } catch (error) {
      HTTPForCarCleLogger.error(`err=${error}`)
    }
  }

  public async httpForGetPostList(): Promise<postDataType[] | null> {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForCarCleLogger.error('HttpRequest对象创建失败')
    }

    HTTPForCarCleLogger.info(`JWT=${this.JWT}`)

    try {
      const res = await httpRequest.request(
        this.getPostListUrl,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.JWT.trim()}`
          }
        })

      if (res.responseCode !== 200) {
        HTTPForCarCleLogger.error('request失败:' + `responseCode=${res.responseCode}, resultType=${res.resultType}`)
        return null
      }

      const msg = res.result as string | returnPostListType
      HTTPForCarCleLogger.info(`msg=${msg}`)

      const response: returnPostListType =
        typeof msg === 'string' ? JSON.parse(msg) as returnPostListType : msg

      if (response.code !== 0) {
        HTTPForCarCleLogger.error(`request失败: request.code=${response.code}, response.msg=${response.msg}`)
        return null
      }
      HTTPForCarCleLogger.info(`response=${response}`)
      return response.data.list

      // const data: returnPostListType = {
      //   code: 0,
      //   msg: '',
      //   data: {
      //     total: 1,
      //     list: []
      //   }
      // }
      // return data.data.list
    } catch (error) {
      HTTPForCarCleLogger.error(`err=${error}`)
      return null
    }
  }

  public async httpForLikeState(curState: boolean, id: number): Promise<boolean | null> {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForCarCleLogger.error('HttpRequest对象创建失败')
    }

    HTTPForCarCleLogger.info(`JWT=${this.JWT}`)

    try {
      const res = await httpRequest.request(
        this.praisePostUrl + id + '/like',
        {
          method: curState ? http.RequestMethod.DELETE : http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.JWT.trim()}`
          }
        })

      if (res.responseCode !== 200) {
        HTTPForCarCleLogger.error('request失败:' + `responseCode=${res.responseCode}, resultType=${res.resultType}`)
        return null
      }

      const msg = res.result as string | returnPraiseStateType
      HTTPForCarCleLogger.info(`msg=${msg}`)

      const response: returnPraiseStateType =
        typeof msg === 'string' ? JSON.parse(msg) as returnPraiseStateType : msg

      if (response.code !== 0) {
        HTTPForCarCleLogger.error(`request失败: request.code=${response.code}, response.msg=${response.msg}`)
        return null
      }
      HTTPForCarCleLogger.info(`response=${response}`)
      return response.data.ok
    } catch (err) {
      HTTPForCarCleLogger.error(`err=${err}`)
      return null
    }
  }

  public async httpForCommentLikeState(curState: boolean, id: number): Promise<boolean | null> {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForCarCleLogger.error('HttpRequest对象创建失败')
    }

    HTTPForCarCleLogger.info(`JWT=${this.JWT}`)

    try {
      const res = await httpRequest.request(
        this.praiseCommentUrl + id + '/like',
        {
          method: curState ? http.RequestMethod.DELETE : http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.JWT.trim()}`
          }
        })

      if (res.responseCode !== 200) {
        HTTPForCarCleLogger.error('request失败:' + `responseCode=${res.responseCode}, resultType=${res.resultType}`)
        return null
      }

      const msg = res.result as string | returnPraiseStateType
      HTTPForCarCleLogger.info(`msg=${msg}`)

      const response: returnPraiseStateType =
        typeof msg === 'string' ? JSON.parse(msg) as returnPraiseStateType : msg

      if (response.code !== 0) {
        HTTPForCarCleLogger.error(`request失败: request.code=${response.code}, response.msg=${response.msg}`)
        return null
      }
      HTTPForCarCleLogger.info(`response=${response}`)
      return response.data.ok
    } catch (err) {
      HTTPForCarCleLogger.error(`err=${err}`)
      return null
    }
  }

  public async httpForFavoriteState(curState: boolean, id: number): Promise<boolean | null> {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForCarCleLogger.error('HttpRequest对象创建失败')
    }

    HTTPForCarCleLogger.info(`JWT=${this.JWT}`)

    try {
      const res = await httpRequest.request(
        this.favoriteCommentUrl + id + '/favorite',
        {
          method: curState ? http.RequestMethod.DELETE : http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.JWT.trim()}`
          }
        })

      if (res.responseCode !== 200) {
        HTTPForCarCleLogger.error('request失败:' + `responseCode=${res.responseCode}, resultType=${res.resultType}`)
        return null
      }

      const msg = res.result as string | returnPraiseStateType
      HTTPForCarCleLogger.info(`msg=${msg}`)

      const response: returnPraiseStateType =
        typeof msg === 'string' ? JSON.parse(msg) as returnPraiseStateType : msg

      if (response.code !== 0) {
        HTTPForCarCleLogger.error(`request失败: request.code=${response.code}, response.msg=${response.msg}`)
        return null
      }
      HTTPForCarCleLogger.info(`response=${response}`)
      return response.data.ok
    } catch (err) {
      HTTPForCarCleLogger.error(`err=${err}`)
      return null
    }
  }

  public async httpForGetPostTopCommentList(id: number): Promise<topComment_dataType | null> {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForCarCleLogger.error('HttpRequest对象创建失败')
    }

    HTTPForCarCleLogger.info(`JWT=${this.JWT}`)

    try {
      const res = await httpRequest.request(
        this.getPostTopCommentUrl + id + '/comments',
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.JWT.trim()}`
          }
        })

      if (res.responseCode !== 200) {
        HTTPForCarCleLogger.error('request失败:' + `responseCode=${res.responseCode}, resultType=${res.resultType}`)
        return null
      }

      const msg = res.result as string | returnPostTopCommentListType
      HTTPForCarCleLogger.info(`msg=${msg}`)

      const response: returnPostTopCommentListType =
        typeof msg === 'string' ? JSON.parse(msg) as returnPostTopCommentListType : msg

      if (response.code !== 0) {
        HTTPForCarCleLogger.error(`request失败: request.code=${response.code}, response.msg=${response.msg}`)
        return null
      }
      HTTPForCarCleLogger.info(`response=${response}`)
      return response.data
    } catch (error) {
      HTTPForCarCleLogger.error(`err=${error}`)
      return null
    }
  }

  public async httpForGetPostInnerCommentList(id: number): Promise<innerComment_dataType | null> {
    let httpRequest = http.createHttp()
    if (!httpRequest) {
      HTTPForCarCleLogger.error('HttpRequest对象创建失败')
    }
    if (id === null) {
      return null
    }

    HTTPForCarCleLogger.info(`JWT=${this.JWT}`)

    try {
      const res = await httpRequest.request(
        this.getPostInnerCommentUrl + id + '/replies',
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.JWT.trim()}`
          }
        })

      if (res.responseCode !== 200) {
        HTTPForCarCleLogger.error('request失败:' + `responseCode=${res.responseCode}, resultType=${res.resultType}`)
        return null
      }

      const msg = res.result as string | returnPostInnerCommentListType
      HTTPForCarCleLogger.info(`msg=${msg}`)

      const response: returnPostInnerCommentListType =
        typeof msg === 'string' ? JSON.parse(msg) as returnPostInnerCommentListType : msg

      if (response.code !== 0) {
        HTTPForCarCleLogger.error(`request失败: request.code=${response.code}, response.msg=${response.msg}`)
        return null
      }
      HTTPForCarCleLogger.info(`response=${response}`)
      return response.data
    } catch (error) {
      HTTPForCarCleLogger.error(`err=${error}`)
      return null
    }
  }
}