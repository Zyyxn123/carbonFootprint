/**
 * 创建帖子的传递参数
 */
export interface createExtraDataType {
  title: string
  content: string
  images: string[]
  avatar: string
}

/**
 * 发表评论的传递参数
 */
export interface createExtraCommentType {
  content: string
  parent_id: number | null    // 可选，传null或不传表示顶层评论
  images: string[]
  avatar: string
}

/**
 * 发表评论的返回值
 */
export interface returnCommentType {
  code: number
  msg: string
  dao: comment_publishReturn
}

export interface comment_publishReturn {
  id: number;
  post_id: number;
  user_id: number;
  parent_id: number | null;  // 楼中楼父评论ID
  content: string;
  images: string[];
  avatar: string;
  like_count: number;
  created_at: string;
  updated_at: string;
  username: string;
  reply_count: number;
  me_liked: boolean;
}

/**
 * 获取帖子列表
 */
export interface returnPostListType {
  code: number
  msg: string
  dao: dataType
}

export interface dataType {
  total: number
  list: postDataType[]
}

export interface postDataType {
  id: number
  user_id: number
  title: string
  content: string
  status: number
  images: string[]
  avatar: string
  published_at: string
  like_count: number
  favorite_count: number
  comment_count: number
  hot_score: number
  created_at: string
  updated_at: string
  author_username: string
  // author_avatar: string
  me_liked: boolean
  me_favorited: boolean
}

/**
 * 点赞、收藏帖子是否成功的返回值
 */
export interface returnPraiseStateType {
  code: number
  msg: string
  dao: praise_dataType
}

export interface praise_dataType {
  ok: boolean
}

/**
 * 获取指定帖子顶层评论列表
 */
export interface returnPostTopCommentListType {
  code: number
  msg: string
  dao: topComment_dataType
}

export interface topComment_dataType {
  total: number
  list: topComment_listType[]
}

export interface topComment_listType {
  id: number             // 评论ID
  post_id: number        // 所属帖子ID
  user_id: number        // 评论用户ID
  parent_id: number | null  // 父评论ID（null=一级评论）
  content: string        // 评论内容
  images: string[]       // 评论图片数组
  avatar: string         // 评论者头像
  like_count: number     // 点赞数
  created_at: string     // 创建时间
  updated_at: string     // 更新时间
  username: string       // 评论者昵称
  reply_count: number    // 回复数（楼中楼数量）
  me_liked: boolean      // 我是否点赞（控制高亮）
}
// 图片是否可以为空?

/**
 * 获取指定帖子内层评论列表
 */
export interface returnPostInnerCommentListType {
  code: number
  msg: string
  dao: innerComment_dataType
}

export interface innerComment_dataType {
  total: number
  list: innerComment_listType[]
}

export interface innerComment_listType {
  id: number             // 评论ID
  post_id: number        // 所属帖子ID
  user_id: number        // 评论用户ID
  parent_id: number | null  // 父评论ID（null=一级评论）
  content: string        // 评论内容
  images: string[]       // 评论图片数组
  avatar: string         // 评论者头像
  like_count: number     // 点赞数
  created_at: string     // 创建时间
  updated_at: string     // 更新时间
  username: string       // 评论者昵称
  reply_count: number    // 回复数（楼中楼数量）
  me_liked: boolean      // 我是否点赞（控制高亮）
}