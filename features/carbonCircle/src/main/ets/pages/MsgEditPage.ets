import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { backButton } from "../Components/BackButton"
import { camera, cameraPicker as picker } from '@kit.CameraKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import common from "@ohos.app.ability.common"
import { ColorMetrics, screenshot } from "@kit.ArkUI";
import userDataVM from "../ViewModel/UserDataViewModel";

@Component
struct MsgEditPage {
  @State selectedImgIndex: number = -1
  @State selectedUris: string[] = []
  @State hasContent: boolean = false
  @State textStr: string = ''
  @State isShow: boolean = false
  @State imgSrc: string[] = []
  @State videoSrc: string = ''
  @State showDeleteArea: boolean = false
  @State canDeleteImg: boolean = false
  @State offsetX: number = 0
  @State offsetY: number = 0
  @State titleStr: string = ''
  @State isLoading: boolean = false

  aboutToAppear(): void {
    userDataVM.getUserData()
  }

  createPhSelectOptions(): photoAccessHelper.PhotoSelectOptions {
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
    photoSelectOptions.maxSelectNumber = 9
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    photoSelectOptions.isPhotoTakingSupported = true
    return photoSelectOptions
  }

  createPickerProfile(context: Context): picker.PickerProfile {
    let pickerProfile: picker.PickerProfile = {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_UNSPECIFIED,
      videoDuration: 360
    }
    return pickerProfile
  }

  async getPickerResult(context: Context, pickerProfile: picker.PickerProfile) {
    if (this.imgSrc.length >= 9) {
      this.getUIContext().getPromptAction().showToast({
        message: "最多只能选择9张图片",
        duration: 1500
      });
      return;
    }

    let result = await picker.pick(context,
      [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO],
      pickerProfile
    )

    console.info(`拍照结果: ${result.resultUri}`)

    if (result.resultCode == 0) {
      if (result.mediaType === picker.PickerMediaType.PHOTO) {
        const uri = result.resultUri
        if (uri && !this.imgSrc.includes(uri)) {
          this.imgSrc.push(uri)
        }
      } else {
        this.videoSrc = result.resultUri
      }
    }

    if (this.imgSrc.length !== 0) {
      this.hasContent = true
    } else {
      this.hasContent = false
    }
  }

  async getMediaPickerResult(
    photoSelectOptions: photoAccessHelper.PhotoSelectOptions,
    context: common.UIAbilityContext
  ) {
    let photoPicker = new photoAccessHelper.PhotoViewPicker()

    photoPicker.select(photoSelectOptions).then((res) => {

      res.photoUris.forEach(uri => {
        if (uri && !this.imgSrc.includes(uri) && this.imgSrc.length < 9) {
          this.imgSrc.push(uri)
          console.info('选择的图片：', JSON.stringify(uri))
        }
      })
      if (this.imgSrc.length !== 0) {
        this.hasContent = true
      } else {
        this.hasContent = false
      }
    }).catch((err: BusinessError) => {
      console.error(`选择失败: ${err.message}`)
    })
  }

  getContext(): Context | undefined {
    let uiContext = this.getUIContext()
    return uiContext.getHostContext()
  }

  @Builder
  selectPhBuilder() {
    Column() {
      Text() {
        Span('拍照\n').fontSize(15).fontColor('#000')
        Span('照片或视频').fontSize(12).fontColor('#B2B2B2')
      }
      .width('100%')
      .textAlign(TextAlign.Center)
      .margin({ top: 6 })
      .height(40)
      .onClick(async () => {
        let context = this.getContext()
        if (!context) {
          this.getUIContext().getPromptAction().showToast({ message: '调取失败' })
          return
        }
        let profile = this.createPickerProfile(context)
        await this.getPickerResult(context, profile)
        this.isShow = false
      })

      Divider().width('100%').strokeWidth(1).color('#F2F2F2').margin({ top: 8, bottom: 12 })

      Text('从相册选择')
        .fontSize(15)
        .fontColor('#000')
        .width('100%')
        .textAlign(TextAlign.Center)
        .height(30)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext
          if (!context) {
            return
          }
          let opts = this.createPhSelectOptions()
          this.getMediaPickerResult(opts, context)
          this.isShow = false
        })

      Divider().color('#F2F2F2').strokeWidth(6).margin({ top: 15, bottom: 15 })

      Text('取消')
        .fontSize(15)
        .fontColor('#000')
        .width('100%')
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.isShow = false
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.showDeleteArea) {
        Column() {
          Text('拖动到此处删除')
            .fontSize(16)
            .fontColor('#000')
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height(120)
        .width('100%')
        .backgroundColor(this.canDeleteImg ? '#F64444' : '#ccffb6b6')
      }

      Column() {
        backButton({
          pageTitle: '编辑',
          hasContent: this.hasContent,
          imgSrc: this.imgSrc,
          textStr: this.textStr,
          titleStr: this.titleStr,
          isLoading: this.isLoading
        })
          .margin({ bottom: 50 })

        Column({ space: 20 }) {
          Row({ space: 5 }) {
            Text('标题：')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#000')

            TextInput({ placeholder: '标题(选，最多十字)', text: $$this.titleStr })
              .placeholderColor('#B2B2B2')
              .maxLines(1)
              .maxLength(10)
              .fontColor('#000')
              .fontSize(16)
              .backgroundColor(Color.Transparent)
              .layoutWeight(1)
          }
          .justifyContent(FlexAlign.Start)
          .width('100%')
          .border({ width: { bottom: 1 }, color: '#ccc' })

          TextArea({ placeholder: '这一刻的想法...(必填)', text: $$this.textStr })
            .placeholderColor('#B2B2B2')
            .maxLines(5)
            .maxLength(100)
            .fontColor('#000')
            .fontSize(14)
            .width('100%')
            .showCounter(true, {
              counterTextColor: ColorMetrics.rgba(0, 0, 0)
            })
            .backgroundColor(Color.Transparent)
            .onChange(() => {
              if (this.textStr.length <= 100) {

              }
              if (this.textStr !== '') {
                this.hasContent = true
              } else {
                this.hasContent = false
              }
            })

          List() {
            ForEach(this.imgSrc, (item: string, index: number) => {
              ListItem() {
                Image(item)
                  .width(100)
                  .height(100)
                  .objectFit(ImageFit.Cover)
                  .zIndex(this.selectedImgIndex === index ? 10 : 1)
                  .opacity(this.selectedImgIndex === index ? 0.5 : 1)
                  .translate(this.selectedImgIndex === index ? { x: this.offsetX, y: this.offsetY, z: 0 } : {})
                  .animation({ duration: 100 })
                  .priorityGesture(
                    GestureGroup(GestureMode.Sequence,
                      LongPressGesture({ fingers: 1, duration: 400 }),
                      PanGesture()
                        .onActionStart(() => {
                          this.showDeleteArea = true
                          this.selectedImgIndex = index
                        })
                        .onActionUpdate((event: GestureEvent | undefined) => {
                          if (event) {
                            this.offsetX = event.offsetX
                            this.offsetY = event.offsetY
                            console.log(`PanGesture success offsetX: ${this.offsetX}, offsetY: ${this.offsetY}`)

                            const group = Math.floor(index / 3)
                            if (this.offsetY >= 415 - group * 100) {
                              this.canDeleteImg = true
                            } else {
                              this.canDeleteImg = false
                            }
                          }
                        })
                        .onActionEnd(() => {
                          if (this.canDeleteImg === true && this.showDeleteArea === true) {
                            const newArr: string[] = [...this.imgSrc.slice(0, index), ...this.imgSrc.slice(index + 1)]
                            this.imgSrc = newArr
                          }
                          if (this.imgSrc.length !== 0) {
                            this.hasContent = true
                          } else {
                            this.hasContent = false
                          }
                          this.showDeleteArea = false
                          this.offsetX = 0
                          this.offsetY = 0
                          this.selectedImgIndex = -1
                        })))
              }
              .margin({ bottom: 6 })
            })

            if (this.imgSrc.length < 9) {
              ListItem() {
                Column() {
                  Text('＋').fontSize(80).fontColor('#888888')
                }
                .width(100)
                .height(100)
                .backgroundColor('#F2F2F2')
                .onClick(() => {
                  this.isShow = true
                })
                .bindSheet($$this.isShow, this.selectPhBuilder(), {
                  height: 200,
                  showClose: false
                })
              }
            }
          }
          .lanes(3)
          .listDirection(Axis.Vertical)
          .edgeEffect(EdgeEffect.None, { alwaysEnabled: false })
          .layoutWeight(1)
        }
        .width('100%')
        .padding({ left: 25, right: 25 })

        if (this.isLoading) {
          Row() {
            LoadingProgress()
              .width(35)
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
        }
      }
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    MsgEditPage()
  }
  .hideTitleBar(true)
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_carboncircle_msgEditingPage
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}