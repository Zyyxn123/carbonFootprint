
export interface aiReportExtraDataType {
  model: string
  messages: rolesType[]
  max_tokens?: number
  stream?: boolean
}

export interface rolesType {
  role: string
  content: string
}

export interface SparkStreamResponse {
  code: number
  message: string
  sid: string
  id: string
  created: number
  choices: StreamChoice[]
  usage?: StreamUsage
}

interface StreamDelta {
  role: string
  content: string
}

interface StreamChoice {
  delta: StreamDelta
  index: number
}

interface StreamUsage {
  prompt_tokens: number
  completion_tokens: number
  total_tokens: number
}