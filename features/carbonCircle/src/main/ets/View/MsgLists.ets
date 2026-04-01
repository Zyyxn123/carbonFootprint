import { MsgListType } from "../Model/MsgListModel"
import msgListVM from "../ViewModel/MsgListViewModel"

@Component
export struct MsgLists {
  @Builder
  listItemBuilder(item: MsgListType, index: number) {
    Column({ space: 8 }) {
      Row({ space: 10 }) {
        Image($r(`app.media.${item.avatar}`))
          .width(40)
          .borderRadius(25)

        Column({ space: 5 }) {
          Text(item.userName)
            .fontSize(15)
            .fontColor('#000')

          Text(item.timeToken.split(' ')[0])
            .fontSize(12)
            .fontColor('#ccc')
        }
      }

      Text(item.text)
        .fontSize(15)
        .fontColor('#000')
        .width('100%')

      Grid() {
        ForEach(item.img, (imgSrc: string, index: number) => {
          GridItem() {
            Image(`${imgSrc}`)
              .width(100)
              .height(100)
              .objectFit(ImageFit.Cover)
          }
        })
      }
      .edgeEffect(EdgeEffect.None, { alwaysEnabled: false })
      .height(Math.ceil(item.img.length / 3) * 105)
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(6)
      .rowsGap(6)

      Row() {
        Row({ space: 6 }) {
          Image($r('app.media.carCircle_praise'))
            .width(20)
            .fillColor('#000')

          Text('5')
            .fontColor('#000')
            .fontSize(15)
        }
        .width('50%')
        .justifyContent(FlexAlign.Center)

        Row({ space: 6 }) {
          Image($r('app.media.carCircle_comment'))
            .width(20)
            .fillColor('#000')

          Text('23')
            .fontColor('#000')
            .fontSize(15)
        }
        .justifyContent(FlexAlign.Center)
        .width('50%')
      }
      .width('100%')
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 20, right: 20 })

    Divider()
      .vertical(false)
      .width('100%')
      .color('#F2F2F2')
      .strokeWidth(2)
      .margin({ top: 8, bottom: 15})
  }

  build() {
    List() {
      ForEach(msgListVM.msgList, (item: MsgListType, index: number) => {
        this.listItemBuilder(item, index)
      })
    }
    .height('100%')
    .width('100%')
  }
}