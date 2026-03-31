import { MsgListType } from "../Model/MsgListModel"

@ObservedV2
class MsgListViewModel {
  @Trace msgList: MsgListType[] = []

  public setMsg(acc: string, name: string, avatar: string,
    imgSrc: string[], textStr: string, date: string,
  likeNum: number) {
    const dataItem: MsgListType = {
      acc: acc,
      avatar: avatar,
      userName: name,
      text: textStr,
      img: imgSrc,
      timeToken: date,
      like: likeNum
    }

    this.msgList.push(dataItem)
  }
}

const msgListVM = new MsgListViewModel()

export default msgListVM