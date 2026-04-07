import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"
import { HTTPForCarCircle, postDataType } from "@ohos/utils"
import { MsgListType } from "../Model/MsgListModel"
import msgListVM from "../ViewModel/MsgListViewModel"

@Component
export struct MsgLists {
  private httpForCarCircleIns: HTTPForCarCircle = HTTPForCarCircle.getInstance()

  @Builder
  listItemBuilder(item: postDataType, index: number) {
    Column({ space: 8 }) {
      Row({ space: 10 }) {
        Image($r(`app.media.${item.avatar}`))
          .width(40)
          .borderRadius(25)

        Column({ space: 5 }) {
          Text(item.author_username + '')
            .fontSize(15)
            .fontColor('#000')

          Text(item.published_at)
            .fontSize(12)
            .fontColor('#ccc')
        }
      }

      Text(item.title)
        .fontSize(18)
        .fontColor('#000')
        .width('100%')
        .maxLines(1)
      Text(item.content)
        .fontSize(15)
        .fontColor('#000')
        .width('100%')

      Grid() {
        ForEach(item.images, (imgSrc: string, index: number) => {
          GridItem() {
            Image(`${imgSrc}`)
              .width(100)
              .height(100)
              .objectFit(ImageFit.Cover)
          }
        })
      }
      .edgeEffect(EdgeEffect.None, { alwaysEnabled: false })
      .height(Math.ceil(item.images.length / 3) * 105)
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(6)
      .rowsGap(6)

      Row() {
        Row({ space: 6 }) {
          Image($r('app.media.carCircle_praise'))
            .width(20)
            .fillColor(item.me_liked ? '#ffff0000' : '#000')

          Text(item.like_count + '')
            .fontColor(item.me_liked ? '#ffff0000' : '#000')
            .fontSize(15)
        }
        .width('33%')
        .justifyContent(FlexAlign.Center)
        .onClick(async () => {
          const result = /*await this.httpForCarCircleIns.httpForLikeState(item.me_liked, item.id)*/true
          if (result) {
            const bol = !item.me_liked
            msgListVM.updatePostLikeStatus(index, bol)
            this.getUIContext().getPromptAction().showToast({
              message: item.me_liked ? '取消点赞' : '点赞成功',
              duration: 1500,
              bottom: 80
            })
          } else {
            this.getUIContext().getPromptAction().showToast({
              message: '点赞失败',
              duration: 1500,
              bottom: 80
            })
          }
        })

        Row({ space: 6 }) {
          Image($r('app.media.carCircle_like'))
            .width(20)
            .fillColor(item.me_favorited ? '#ffff0000' : '#000')

          Text(item.favorite_count + '')
            .fontColor(item.me_favorited ? '#ffff0000' : '#000')
            .fontSize(15)
        }
        .justifyContent(FlexAlign.Center)
        .width('33%')
        .onClick(async () => {
          const result = /*await this.httpForCarCircleIns.httpForFavoriteState(item.me_favorited, item.id)*/true
          if (result) {
            const bol = !item.me_favorited
            msgListVM.updatePostFavoriteStatus(index, bol)
            this.getUIContext().getPromptAction().showToast({
              message: item.me_favorited ? '取消收藏' : '收藏成功',
              duration: 1500,
              bottom: 80
            })
          } else {
            this.getUIContext().getPromptAction().showToast({
              message: '收藏失败',
              duration: 1500,
              bottom: 80,
            })
          }
        })

        Row({ space: 6 }) {
          Image($r('app.media.carCircle_comment'))
            .width(20)
            .fillColor('#000')

          Text(item.comment_count + '')
            .fontColor('#000')
            .fontSize(15)
        }
        .justifyContent(FlexAlign.Center)
        .width('33%')
        .onClick(async () => {
          buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_carboncircle_comment, new Object({
            PostItem: item
          }))
        })
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
      ForEach(msgListVM.msgList, (item: postDataType, index: number) => {
        this.listItemBuilder(item, index)
      })
    }
    .height('100%')
    .width('100%')
  }
}