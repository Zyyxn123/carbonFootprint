import {
  createExtraCommentType,
  createExtraDataType,
  FootprintDao,
  HTTPForCarCircle,
  innerComment_dataType,
  postDataType,
  topComment_dataType
} from "@ohos/utils"

export interface MsgListType {
  acc: string
  avatar: string
  userName: string
  timeToken: string // date.toLocaleString(): '3/30/2026, 8:38:43 PM'
  title: string
  text: string
  img: string[]
  like: number
  favor: number
  comment: number
}

export class MsgListModel {
  private static httpForCarCirIns: HTTPForCarCircle = HTTPForCarCircle.getInstance()

  public static async sendPostToServer(data: createExtraDataType) {
    await MsgListModel.httpForCarCirIns.httpForPublishData(data)
  }

  public static async sendCommentToServer(id: number, data: createExtraCommentType) {
    await MsgListModel.httpForCarCirIns.httpForPublishComment(id, data)
  }

  public static getPostFromServer(): FootprintDao | undefined {
    return MsgListModel.httpForCarCirIns.returnData
  }

  public static async getPostListFromServer(): Promise<postDataType[] | null> {
    return MsgListModel.httpForCarCirIns.httpForGetPostList()
  }

  public static async getPostTopCommentListFromServer(id: number): Promise<topComment_dataType | null> {
    return MsgListModel.httpForCarCirIns.httpForGetPostTopCommentList(id)
  }

  public static async getPostInnerCommentListFromServer(id: number): Promise<innerComment_dataType | null> {
    return MsgListModel.httpForCarCirIns.httpForGetPostInnerCommentList(id)
  }

  public static async setCommentLikeStateToServer(bol: boolean, id: number): Promise<boolean | null> {
    return MsgListModel.httpForCarCirIns.httpForCommentLikeState(bol, id)
  }
}