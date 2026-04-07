// 通用 HTTP 响应包装（你自己的外层）
export interface HTTPForDeepSeekType {
  code: number;
  msg: string;
}

// ==============================================
// AI 流式响应核心接口（已修复，完全匹配你的日志）
// ==============================================
export interface AiChatResponse {
  id: string;
  object: string;
  created: number;
  model: string;
  system_fingerprint?: string;
  choices: DeepSeekStreamChoice[];
  usage?: DeepSeekUsage; // 只有最后一条消息会返回
}

// 流式选择项
export interface DeepSeekStreamChoice {
  index: number
  delta: DeepSeekDelta     // 流式内容
  logprobs: null
  finish_reason: null | 'stop' | string
}

// 流式增量内容（核心）
export interface DeepSeekDelta {
  content?: string;  // 增量文字
  role?: string;     // 可选，有些模型会返回
}

// Tokens 消耗统计（流结束时返回）
export interface DeepSeekUsage {
  prompt_tokens: number;
  completion_tokens: number;
  total_tokens: number;
  prompt_tokens_details: promptDetail
  prompt_cache_hit_tokens: number;
  prompt_cache_miss_tokens: number;
}

interface promptDetail {
  cached_tokens: number;
}