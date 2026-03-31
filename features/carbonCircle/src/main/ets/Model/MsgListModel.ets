export interface MsgListType {
  acc: string
  avatar: string
  userName: string
  text: string
  img: string[]
  timeToken: string // date.toLocaleString(): '3/30/2026, 8:38:43 PM'
  like: number
}

class MsgListModel {}