// export interface HealthyNewsType {
//   uniquekey: string,
//   title: string,
//   date: string,
//   category: string,
//   author_name: string,
//   url: string,
//   thumbnail_pic_s: string,
//   is_content: string
// }
/**
 * 健康资讯列表接口返回的单个资讯项类型
 */
export interface HealthNewsItem {
  /** 资讯唯一标识 */
  uniquekey: string;
  /** 资讯标题 */
  title: string;
  /** 发布时间（格式：YYYY-MM-DD HH:mm:ss） */
  date: string;
  /** 资讯分类（固定为"健康"） */
  category: string;
  /** 作者/来源名称 */
  author_name: string;
  /** 资讯详情链接 */
  url: string;
  /** 缩略图1（可能为空字符串） */
  thumbnail_pic_s: string;
  /** 缩略图2（可选字段） */
  // thumbnail_pic_s02?: string;
  // /** 缩略图3（可选字段） */
  // thumbnail_pic_s03?: string;
  /** 是否有正文内容（1表示有） */
  is_content: string;
}

/**
 * 接口返回结果的核心数据类型
 */
export interface HealthNewsResult {
  /** 状态码（1表示成功） */
  stat: string;
  /** 健康资讯列表 */
  data: HealthNewsItem[];
  /** 当前页码 */
  page: string;
  /** 每页条数 */
  pageSize: string;
}

/**
 * 健康资讯列表接口的完整返回类型
 */
export interface HealthNewsResponse {
  /** 请求结果描述 */
  reason: string;
  /** 核心结果数据 */
  result: HealthNewsResult;
  /** 错误码（0表示无错误） */
  error_code: number;
}