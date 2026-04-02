export interface loginExtraDataType {
  account: string
  password: string
  device_id: string
}

export interface ReturnDataType {
  code: number
  msg: string
  dao: daoType
}

interface daoType {
  user_id: number
  username: string
  access_token: string
  expires_in: number
}