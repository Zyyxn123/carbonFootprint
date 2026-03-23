export interface ExtraDataType {
  account: string
  password: string
  device_id: string
}

export interface ReturnDataType {
  // code: number
  // msg: string
  // dao: userType
  UserID: number
  Username: string
  AccessToken: string
  ExpiresIN: number
}

// interface userType {
//   user_id: number
//   username: string
//   access_token: string
//   expires_in: number
// }