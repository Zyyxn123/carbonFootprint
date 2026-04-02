export interface createExtraData {
  title: string
  content: string
  images: string[]
  avatar: string
}

export interface returnPostType {
  ID: number;
  UserID: number;
  Title: string;
  Content: string;
  Status: number;
  Images: string; // JSON 字符串
  Avatar: string;
  PublishedAt: string; // ISO 时间字符串
  LikeCount: number;
  FavoriteCount: number;
  CommentCount: number;
  HotScore: number;
  CreatedAt: string; // ISO 时间字符串
  UpdatedAt: string; // ISO 时间字符串
}