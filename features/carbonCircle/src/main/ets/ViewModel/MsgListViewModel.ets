import {
  createExtraCommentType,
  createExtraDataType,
  innerComment_listType,
  postDataType,
  topComment_listType
} from "@ohos/utils"
import { MsgListModel } from "../Model/MsgListModel"

@ObservedV2
class MsgListViewModel {
  @Trace msgList: postDataType[] = [
    // {
    //   id: 1,
    //   user_id: 1,
    //   title: '结构体',
    //   content: '里面所有的结构体就直接按里面那个写法照写就行，我给你写的时候就是按照给你返回的JSON的字段形式写的',
    //   status: 1,
    //   images: [],
    //   avatar: 'avatar_1th',
    //   published_at: '3/25/2026',
    //   like_count: 5,
    //   favorite_count: 10,
    //   comment_count: 15,
    //   hot_score: 20,
    //   created_at: 'ddd',
    //   updated_at: 'eee',
    //   author_username: '流年似水',
    //   author_avatar: 'ggg',
    //   me_liked: true,
    //   me_favorited: false
    // }
  ]
  @Trace commentList: topComment_listType[] = [
    // {
    //   id: 1, // 评论ID
    //   post_id: 0, // 所属帖子ID
    //   user_id: 0, // 评论用户ID
    //   parent_id: 0, // 父评论ID（null=一级评论）
    //   content: 'TypeScript 中使⽤的异步编程是⼀种处理并发的，学习如何处理并发问题。 多线程这种处理并发的能⼒在后续 ArkTS 的学习中也会着重进⾏学习，现阶段了解概念即可。', // 评论内容
    //   images: [], // 评论图片数组
    //   avatar: 'avatar_1th', // 评论者头像
    //   like_count: 0, // 点赞数
    //   created_at: '3/24/2026', // 创建时间
    //   updated_at: 'string', // 更新时间
    //   username: '流年似水', // 评论者昵称
    //   reply_count: 0, // 回复数（楼中楼数量）
    //   me_liked: false      // 我是否点赞（控制高亮）
    // },
    // {
    //   id: 1, // 评论ID
    //   post_id: 0, // 所属帖子ID
    //   user_id: 0, // 评论用户ID
    //   parent_id: 0, // 父评论ID（null=一级评论）
    //   content: 'TypeScript 中使⽤的异步编程是⼀种处理并发的，学习如何处理并发问题。 多线程这种处理并发的能⼒在后续 ArkTS 的学习中也会着重进⾏学习，现阶段了解概念即可。', // 评论内容
    //   images: [], // 评论图片数组
    //   avatar: 'avatar_1th', // 评论者头像
    //   like_count: 0, // 点赞数
    //   created_at: '3/24/2026', // 创建时间
    //   updated_at: 'string', // 更新时间
    //   username: '流年似水', // 评论者昵称
    //   reply_count: 30, // 回复数（楼中楼数量）
    //   me_liked: false      // 我是否点赞（控制高亮）
    // },
    // {
    //   id: 1, // 评论ID
    //   post_id: 0, // 所属帖子ID
    //   user_id: 0, // 评论用户ID
    //   parent_id: 0, // 父评论ID（null=一级评论）
    //   content: 'TypeScript 中使⽤的异步编程是⼀种处理并发的，学习如何处理并发问题。 多线程这种处理并发的能⼒在后续 ArkTS 的学习中也会着重进⾏学习，现阶段了解概念即可。', // 评论内容
    //   images: [], // 评论图片数组
    //   avatar: 'avatar_1th', // 评论者头像
    //   like_count: 0, // 点赞数
    //   created_at: '3/24/2026', // 创建时间
    //   updated_at: 'string', // 更新时间
    //   username: '流年似水', // 评论者昵称
    //   reply_count: 30, // 回复数（楼中楼数量）
    //   me_liked: false      // 我是否点赞（控制高亮）
    // }
  ]
  @Trace commentSum: number = 3
  @Trace innerCommentList: innerComment_listType[] = [
    {
      id: 1, // 评论ID
      post_id: 0, // 所属帖子ID
      user_id: 0, // 评论用户ID
      parent_id: 0, // 父评论ID（null=一级评论）
      content: 'TypeScript 中使⽤的异步编程是⼀种处理并发的，学习如何处理并发问题。 多线程这种处理并发的能⼒在后续 ArkTS 的学习中也会着重进⾏学习，现阶段了解概念即可。', // 评论内容
      images: [], // 评论图片数组
      avatar: 'avatar_1th', // 评论者头像
      like_count: 0, // 点赞数
      created_at: '3/24/2026', // 创建时间
      updated_at: 'string', // 更新时间
      username: '流年似水', // 评论者昵称
      reply_count: 0, // 回复数（楼中楼数量）
      me_liked: false      // 我是否点赞（控制高亮）
    },
    {
      id: 1, // 评论ID
      post_id: 0, // 所属帖子ID
      user_id: 0, // 评论用户ID
      parent_id: 0, // 父评论ID（null=一级评论）
      content: 'TypeScript 中使⽤的异步编程是⼀种处理并发的，学习如何处理并发问题。 多线程这种处理并发的能⼒在后续 ArkTS 的学习中也会着重进⾏学习，现阶段了解概念即可。', // 评论内容
      images: [], // 评论图片数组
      avatar: 'avatar_1th', // 评论者头像
      like_count: 1, // 点赞数
      created_at: '3/24/2026', // 创建时间
      updated_at: 'string', // 更新时间
      username: '流年似水', // 评论者昵称
      reply_count: 30, // 回复数（楼中楼数量）
      me_liked: false      // 我是否点赞（控制高亮）
    }
  ]
  @Trace innerCommentSum: number = 2
  @Trace isOK: boolean = true
  @Trace first: boolean = true

  public async sendPostToServer(title: string, text: string, imgSrc: string[], avatar: string) {
    const dataItem: createExtraDataType = {
      title: title,
      content: text,
      images: imgSrc,
      avatar: avatar
    }

    await MsgListModel.sendPostToServer(dataItem)
  }

  public getPostFromServer() {
    this.isOK = true
    const data = MsgListModel.getPostFromServer()
    if (data === undefined) {
      this.isOK = false
      return
    }
  }

  public async getPostListFromServer() {
    const postList = await MsgListModel.getPostListFromServer()
    if (postList === null) {
      return
    }
    this.msgList = postList
  }

  public updatePostLikeStatus(index: number, liked: boolean) {
    let item = this.msgList[index]
    let newItem: postDataType = {
      id: item.id,
      user_id: item.user_id,
      title: item.title,
      content: item.content,
      status: item.status,
      images: item.images,
      avatar: item.avatar,
      published_at: item.published_at,
      like_count: liked ? item.like_count + 1 : item.like_count - 1,
      favorite_count: item.favorite_count,
      comment_count: item.comment_count,
      hot_score: item.hot_score,
      created_at: item.created_at,
      updated_at: item.updated_at,
      author_username: item.author_username,
      me_liked: liked,
      me_favorited: item.me_favorited
    }
    this.msgList[index] = newItem
  }

  public updateCommentLikeStatus(index: number, liked: boolean) {
    let item = this.commentList[index]
    let newItem: topComment_listType = {
      id: item.id,
      post_id: item.post_id,
      user_id: item.user_id,
      parent_id: item.parent_id,
      content: item.content,
      images: item.images,
      avatar: item.avatar,
      like_count: liked ? item.like_count + 1 : item.like_count - 1,
      created_at: item.created_at,
      updated_at: item.updated_at,
      username: item.username,
      reply_count: item.reply_count,
      me_liked: liked,
    }
    this.commentList[index] = newItem
  }

  public updateInnerCommentLikeStatus(index: number, liked: boolean) {
    let item = this.innerCommentList[index]
    let newItem: innerComment_listType = {
      id: item.id,
      post_id: item.post_id,
      user_id: item.user_id,
      parent_id: item.parent_id,
      content: item.content,
      images: item.images,
      avatar: item.avatar,
      like_count: liked ? item.like_count + 1 : item.like_count - 1,
      created_at: item.created_at,
      updated_at: item.updated_at,
      username: item.username,
      reply_count: item.reply_count,
      me_liked: liked,
    }
    this.innerCommentList[index] = newItem
  }

  public updatePostFavoriteStatus(index: number, favorited: boolean) {
    let item = this.msgList[index]
    let newItem: postDataType = {
      id: item.id,
      user_id: item.user_id,
      title: item.title,
      content: item.content,
      status: item.status,
      images: item.images,
      avatar: item.avatar,
      published_at: item.published_at,
      like_count: item.like_count,
      favorite_count: favorited ? item.favorite_count + 1 : item.favorite_count - 1,
      comment_count: item.comment_count,
      hot_score: item.hot_score,
      created_at: item.created_at,
      updated_at: item.updated_at,
      author_username: item.author_username,
      me_liked: item.me_liked,
      me_favorited: favorited
    }
    this.msgList[index] = newItem
  }

  public async getPostTopCommentListFromServer(id: number) {
    const postList = await MsgListModel.getPostTopCommentListFromServer(id)
    if (postList === null) {
      return
    }
    this.commentList = postList.list
    this.commentSum = postList.total
  }

  public async getPostInnerCommentListFromServer(id: number) {
    const postList = await MsgListModel.getPostInnerCommentListFromServer(id)
    if (postList === null) {
      return
    }
    this.innerCommentList = postList.list
    this.innerCommentSum = postList.total
  }

  public async sendCommentToServer(id: number | undefined, content: string,
    parent_id: number | null, imgSrc: string[], avatar: string | undefined) {
    if (id === undefined || avatar === undefined) {
      return
    }
    const dataItem: createExtraCommentType = {
      content: content,
      parent_id: parent_id,
      images: imgSrc,
      avatar: avatar
    }

    await MsgListModel.sendCommentToServer(id, dataItem)
  }

  public updateTopCommentLikeStatus(index: number, liked: boolean) {
    let item = this.msgList[index]
    let newItem: postDataType = {
      id: item.id,
      user_id: item.user_id,
      title: item.title,
      content: item.content,
      status: item.status,
      images: item.images,
      avatar: item.avatar,
      published_at: item.published_at,
      like_count: liked ? item.like_count + 1 : item.like_count - 1,
      favorite_count: item.favorite_count,
      comment_count: item.comment_count,
      hot_score: item.hot_score,
      created_at: item.created_at,
      updated_at: item.updated_at,
      author_username: item.author_username,
      me_liked: liked,
      me_favorited: item.me_favorited
    }
    this.msgList[index] = newItem
  }

  public async setCommentLikeStateToServer(bol: boolean, id: number): Promise<boolean> {
    const res = await MsgListModel.setCommentLikeStateToServer(bol, id)
    if (res === null) {
      return false
    }
    return res
  }
}

const msgListVM = new MsgListViewModel()

export default msgListVM