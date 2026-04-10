import { BuilderNameConstants, buildRouterModel, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { HTTPForCarCircle, postDataType, topComment_dataType, topComment_listType } from "@ohos/utils"
import { JSON } from "@kit.ArkTS"
import { BackButtonOri } from "../Components/BackButtonOri"
import msgListVM from "../ViewModel/MsgListViewModel"
import { ColorMetrics } from "@kit.ArkUI"

@Component
export struct CommentsPage {
  @Prop val: object
  @State up: boolean = false
  @State item: postDataType | undefined = undefined
  @State isShow: boolean = false
  @State commentStr: string = ''
  @State isShowComment: boolean = false
  @State isTopComment: boolean = false
  @State sendId: number = 0
  @State imgSrc: string[] = []

  aboutToAppear(): void {
    setTimeout(() => {
      this.isShow = true
    }, 600)

    try {
      const data: valueType = JSON.parse(JSON.stringify(this.val)) as valueType
      this.item = data.PostItem
      console.info('解析帖子数据成功:' + JSON.stringify(this.item))
      msgListVM.getPostTopCommentListFromServer(this.item.id)
    } catch (err) {
      this.getUIContext().getPromptAction().showToast({
        message: '解析帖子数据失败，请退出重新尝试',
        duration: 1500,
        bottom: 80
      })
      console.error('解析帖子数据失败，请退出重新尝试:' + err)
    }
  }

  getRandomInt(): number {
    // 核心公式：Math.random() 生成 0~1(不含1) 的随机数，*20 得到 0~20(不含20)，向下取整为 0~19，+1 得到 1~20
    return Math.floor(Math.random() * 20) + 1;
  }

  build() {
    Column() {
      Column() {
        BackButtonOri({ pageTitle: '帖子详情' })

        if (this.isShow && this.item !== undefined) {
          List() {
            ListItem() {
              Column({ space: 8 }) {
                Row({ space: 10 }) {
                  Image($r(`app.media.avatar_a0${this.getRandomInt()}`))
                    .width(50)
                    .borderRadius(25)

                  Text(this.item.author_username + '')
                    .fontSize(16)
                    .fontColor('#000')
                }

                Text(this.item.title)
                  .fontSize(19)
                  .fontColor('#000')
                  .width('100%')
                  .maxLines(1)
                Text(this.item.content)
                  .fontSize(16)
                  .fontColor('#000')
                  .width('100%')

                Grid() {
                  ForEach(this.item.images, (imgSrc: string, index: number) => {
                    GridItem() {
                      Image(`${imgSrc}`)
                        .width(100)
                        .height(100)
                        .objectFit(ImageFit.Cover)
                    }
                  })
                }
                .edgeEffect(EdgeEffect.None, { alwaysEnabled: false })
                .height(Math.ceil(this.item.images?.length / 3) * 105)
                .columnsTemplate('1fr 1fr 1fr')
                .columnsGap(6)
                .rowsGap(6)

                Text(this.item.published_at.split('T')[0])
                  .fontSize(1)
                  .fontSize(15)
                  .fontColor('#ccc')

                Column() {
                  Text('评论 ' + this.item.comment_count)
                    .fontSize(18)
                    .fontColor('#000')
                    .margin(8)

                  Divider()
                    .color('#B2B2B2')
                    .width('100%')
                    .strokeWidth(1)
                    .vertical(false)
                    .margin({ bottom: 8 })

                  ForEach(msgListVM.commentList, (item: topComment_listType, index: number) => {
                    Row({ space: 6 }) {
                      Image(/*$r(`app.media.${item.avatar}`)*/$r(`app.media.avatar_a0${this.getRandomInt()}`))
                        .width(35)
                        .borderRadius(20)
                        .margin({ left: 6 })

                      Column({ space: 5 }) {
                        Text(/*item.username*/$r(`app.string.userName_a0${this.getRandomInt()}`))
                          .fontColor('#000')
                          .fontSize(16)

                        Text(item.content)
                          .fontWeight(FontWeight.Regular)
                          .fontSize(15)
                          .fontColor('#000')

                        Row({ space: 6 }) {
                          Text(item.created_at.split('T')[0])
                            .fontSize(12)
                            .fontColor('#ff7a7a7a')

                          Row({ space: 5 }) {
                            Text('回复')
                              .fontSize(14)
                              .fontColor('#000')

                            Text(item.reply_count + '')
                              .fontSize(14)
                              .fontColor('#000')
                          }
                          .layoutWeight(1)
                          .margin({ left: 5 })
                          .onClick(() => {
                            this.commentStr = ''
                            this.isShowComment = true
                            this.isTopComment = false
                            this.sendId = item.id
                          })

                          Row({ space: 5 }) {
                            Image($r('app.media.carCircle_like'))
                              .fillColor(item.me_liked ? '#ffff0000' : '#000')
                              .width(20)
                              .onClick(async () => {
                                const result: boolean = await msgListVM.setCommentLikeStateToServer(item.me_liked, item.id)
                                if (result) {
                                  const bol = !item.me_liked
                                  msgListVM.updateCommentLikeStatus(index, bol)
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

                            Text(item.like_count + '')
                              .fontColor(item.me_liked ? '#ffff0000' : '#000')
                              .fontSize(15)
                          }
                        }
                        .margin({ top: 5 })
                        .padding({ right: 15, bottom: 10 })
                        .width('100%')

                        if (item.reply_count !== 0) {
                          Text('查看 ' + item.reply_count + ' 条回复 >')
                            .padding(7)
                            .fontSize(15)
                            .fontColor('#000')
                            .backgroundColor('#ffeaeaea')
                            .borderRadius(15)
                            .margin({ bottom: 15 })
                            .onClick(async () => {
                              buildRouterModel(RouterNameConstants.ENTRY_HAP, BuilderNameConstants.HAR_carboncircle_innerComment, new Object({
                                commentItem: item
                              }))
                            })
                        }
                      }
                      .alignItems(HorizontalAlign.Start)
                      .layoutWeight(1)
                    }
                    .alignItems(VerticalAlign.Top)
                    .width('100%')
                  })
                }
                .justifyContent(FlexAlign.Start)
                .alignItems(HorizontalAlign.Center)
                .borderRadius(15)
                .backgroundColor('#fffafafa')
                .width('100%')
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
          }
          .width('100%')
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          .layoutWeight(1)
          .padding({ left: 20, right: 20 })
          .onClick(() => {
            this.isShowComment = false
            this.commentStr = ''
            this.up = false
          })

          if (this.isShowComment) {
            Column() {
              TextArea({ placeholder: '理性发言，友善互动', text: $$this.commentStr })
                .fontSize(16)
                .placeholderColor('#B2B2B2')
                .borderRadius(15)
                .padding(8)
                .width('100%')
                .fontColor('#000')
                .backgroundColor('#fff6f6f6')
                .height(120)
                .borderRadius({ topLeft: 20, topRight: 20 })
                .showCounter(true, {
                  counterTextColor: ColorMetrics.rgba(0, 0, 0)
                })
                .onFocus(() => {
                  this.up = true
                })
                .enableKeyboardOnFocus(true)

              Row() {
                Image($r('app.media.carCircle_images'))
                  .fillColor('#000')
                  .width(30)
                  .onClick(() => {
                  })

                Text('发布')
                  .fontSize(17)
                  .fontColor(this.commentStr === '' ? '#ffa3bfec' : '#ff1c6df1')
                  .onClick(() => {
                    if (this.commentStr === '') {
                      this.getUIContext().getPromptAction().showToast({
                        message: '评论内容必填',
                        duration: 1000,
                        bottom: 80
                      })
                    } else {
                      if (this.isTopComment) {
                        msgListVM.sendCommentToServer(this.item?.id, this.commentStr,
                          null, this.imgSrc, this.item?.avatar)
                      } else {
                        msgListVM.sendCommentToServer(this.item?.id, this.commentStr,
                          this.sendId, this.imgSrc, this.item?.avatar)
                      }
                      this.isShowComment = false
                    }
                    this.commentStr = ''
                  })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Top)
              .width('100%')
              .height(this.up ? 170 : 50)
              .padding({ left: 15, right: 15, top: 15 })
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .height(this.up ? 320 : 200)
            .backgroundColor('#fff')
            .border({ width: { top: 1 }, color: '#ccc' })
            .borderRadius({ topLeft: 20, topRight: 20 })
          } else {
            Row({ space: 15 }) {
              Text('理性发言，友善互动')
                .fontSize(16)
                .borderRadius(15)
                .padding(8)
                .width('80%')
                .fontColor('#ccc')
                .backgroundColor('#fff6f6f6')
                .onClick(() => {
                  this.isShowComment = true
                  this.isTopComment = true
                })

              Text('发布')
                .fontSize(17)
                .fontColor(this.commentStr === '' ? '#ffa3bfec' : '#ff1c6df1')
            }
            .width('100%')
            .height(70)
            .backgroundColor('#fff')
            .padding({ top: 3, left: 20, bottom: 20 })
            .border({ width: { top: 1 }, color: '#ccc' })
          }
        } else {
          LoadingProgress()
            .width(40)
            .color('#37800f')
            .position({ x: 150, y: 350 })
        }
      }
      .width('100%')
      .height('100%')
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height('100%')
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    CommentsPage({ val: value })
  }
  .hideTitleBar(true)
  .title('评论')
  .backgroundColor('#fff')
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_carboncircle_comment
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}

interface valueType {
  PostItem: postDataType
}