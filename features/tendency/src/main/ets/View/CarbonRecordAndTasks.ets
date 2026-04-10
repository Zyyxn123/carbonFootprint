import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"
import { RecordAndTaskTypeModel } from "../Model/RecordAndTaskModel"
import lowTVM from "../ViewModel/LowTaskViewModel"
import RecordAndTaskViewModel from "../ViewModel/RecordAndTaskViewModel"
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { bundleManager } from "@kit.AbilityKit";
import mapFootVM from "../ViewModel/MapFootprintViewModel";

let date = new Date().toLocaleDateString()
AppStorage.setOrCreate('tasksBol', true)
AppStorage.setOrCreate('showIndex', -1)

@Component
export struct carbonRecordAndTasks {
  @State acc: string = AppStorage.get('currLoginAcc') as string
  @StorageLink('showIndex') showIndex: number = -1
  @StorageLink('tasksBol') isShown: boolean = true
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext
  @State bol: boolean = false
  @State isLoad: boolean = true

  async aboutToAppear(): Promise<void> {
    await lowTVM.getTotalData(this.acc, date)
    this.showIndex = await lowTVM.findFirstUnfinishedIndex()
    setTimeout(() => {
      this.isShown = false
      this.isLoad = false
    }, 1500)

    this.bol = await checkPermissions()
    console.info('lowFootprintPage1: ' + this.bol)
  }

  getBgColor(category: string): string {
    const colorMap: Record<string, string> = {
      '出行': '#42B983',
      '饮食': '#FF9A6C',
      '电器': '#5B9DFF',
      '节水': '#61D2C4',
      '生活习惯': '#A188FF',
      '消费': '#FF7575',
      '办公': '#91CA69',
      '绿植': '#52C41A',
      '环保': '#52C41A'
    }
    return colorMap[category] || '#999'
  }

  getTextColor(category: string): string {
    const textColorMap: Record<string, string> = {
      '出行': '#2A8A5F',
      '饮食': '#E07B4F',
      '电器': '#3A7BD5',
      '节水': '#45AFA3',
      '生活习惯': '#7A67D9',
      '消费': '#D95A5A',
      '办公': '#6CA843',
      '绿植': '#3A9112',
      '环保': '#3A9112'
    }
    return textColorMap[category] || '#555'
  }

  getLightBgColor(category: string): string {
    const lightColorMap: Record<string, string> = {
      '出行': '#E6F5F0',
      '饮食': '#FFF0E8',
      '电器': '#EDF4FF',
      '节水': '#E6F7F5',
      '生活习惯': '#F2EEFF',
      '消费': '#FFEFEF',
      '办公': '#F3F9EC',
      '绿植': '#F0F9E8',
      '环保': '#F0F9E8'
    }
    return lightColorMap[category] || '#F5F5F5'
  }

  @Builder
  aiItemBuilder() {
    Column() {
      if (mapFootVM.latelyData === undefined) {
        if (this.isLoad) {
          LoadingProgress()
            .color('#37800f')
            .width(35)
          Text('正在加载中...')
            .fontSize(12)
            .fontColor('#000')
        } else {
          Text('暂无内容')
            .fontSize(12)
            .fontColor('#000')
        }

      } else {
        Column({ space: 10 }) {
          Row({ space: 6 }) {
            Image($r('app.media.tendency_markLocation'))
              .width(40)

            Text(mapFootVM.latelyData.data.titles[0].content)
              .fontSize(20)
              .fontColor('#000')
              .layoutWeight(1)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .margin({ left: 5, right: 5, bottom: 8 })

          Text('+ ' + mapFootVM.latelyData.carEmi + 'g CO₂碳排')
            .fontColor('#37800f')
            .fontSize(16)

          if (mapFootVM.latelyData.extraData === '') {
            Text('暂未设置额外信息')
              .fontSize(18)
              .fontColor('#000')
              .layoutWeight(1)
          } else {
            Text(mapFootVM.latelyData.extraData)
              .layoutWeight(1)
              .maxLines(3)
              .fontSize(16)
              .fontColor('#000')
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }
        .alignItems(HorizontalAlign.Start)
        .padding(10)
        .width('100%')
        .height('100%')
      }
    }
    .linearGradient({
      angle: 225,
      colors: [["#e7fdff", 0.4], ['#ffffff', 0.6]]
    })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }

  @Builder
  tasksItemBuilder(item: RecordAndTaskTypeModel, index: number) {
    if (this.isShown) {
      LoadingProgress()
        .color('#37800f')
        .width(35)
      Text('正在加载中...')
        .fontSize(12)
        .fontColor('#000')
    } else {
      if (this.showIndex === -1) {
        Column() {
          Text('今日任务均已完成!')
            .fontSize(18)
            .fontColor('#000')
            .fontWeight(600)
        }
        .width('100%')
        .height(180)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .linearGradient({
          angle: 225,
          colors: [[item.backgroundColor, 0.4], ['#ffffff', 0.6]]
        })
        .borderRadius(15)
      } else {
        Column({ space: 5 }) {
          Text(lowTVM.taskList[this.showIndex].taskItem.categoryIcon +
            ' ' + lowTVM.taskList[this.showIndex].taskItem.category)
            .padding(6)
            .fontSize(12)
            .fontColor(this.getTextColor(lowTVM.taskList[this.showIndex].taskItem.category))
            .backgroundColor(this.getBgColor(lowTVM.taskList[this.showIndex].taskItem.category))
            .borderRadius(15)

          Text(lowTVM.taskList[this.showIndex].taskItem.title)
            .fontSize(18)
            .fontColor('#000')
            .fontWeight(600)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text('+ ' + lowTVM.taskList[this.showIndex].taskItem.co2Reduction.toString() + 'g CO₂减排')
            .fontColor('#37800f')
            .fontSize(16)

          Button(lowTVM.taskList[this.showIndex].isFinished ? '已完成' : '标记完成')
            .backgroundColor(lowTVM.taskList[this.showIndex].isFinished ? '#ff8c8c8c' : '#37800f')
            .fontColor(lowTVM.taskList[this.showIndex].isFinished ? '#ccc' : '#fff')
            .onClick(async () => {
              if (!lowTVM.taskList[this.showIndex].isFinished) {
                await lowTVM.updateData(this.showIndex)

                this.isShown = true
                setTimeout(async () => {
                  this.showIndex = await lowTVM.findFirstUnfinishedIndex()
                  this.isShown = false
                }, 1000)
              }
            })
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height(180)
        .backgroundColor(this.getLightBgColor(lowTVM.taskList[this.showIndex].taskItem?.category))
        .padding(10)
        .borderRadius(15)
      }
    }
  }

  @Builder
  RecAndTaskBuilder(item: RecordAndTaskTypeModel, index: number) {
    Row() {
      Column() {
        Text(item.title)
          .fontSize(16)
          .width(80)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.recAndTask_title_color'))
          .margin({ left: 15, top: 10, bottom: 6 })
          .fontWeight(600)

        Row() {
          Text(item.content)
            .fontSize(12)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.recAndTask_content_color'))
            .margin(4)
        }
        .borderRadius(15)
        .backgroundColor($r('app.color.recAndTask_background'))
        .justifyContent(FlexAlign.Start)
        .padding(3)
        .margin({ left: 15 })

        Image(item.image)
          .width(index === 0 ? 80 : 90)
          .margin(index === 0 ? { left: 70, top: 20 } : { left: 70, top: 30 })
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height(180)
      .width('48%')
      .border({ width: 1, color: '#ffcdcdcd', radius: 15 })
      .linearGradient({
        angle: 45,
        colors: [[item.backgroundColor, 0.4], ['#ffffff', 0.6]]
      })
      .onClick(() => {
        if (index === 0) {
          buildRouterModel(RouterNameConstants.ENTRY_HAP, item.uri, new Object({
            val: this.bol
          }))
          console.info('lowFootprintPage2: ' + 0)
        } else if (index === 1) {
          buildRouterModel(RouterNameConstants.ENTRY_HAP, item.uri)
          console.info('lowFootprintPage2: ' + 1)
        }
      })

      Column({ space: 15 }) {
        Divider()
          .vertical(false)
          .color('#ccc')
          .strokeWidth(5)
          .width(15)
        Divider()
          .vertical(false)
          .color('#37800f')
          .strokeWidth(5)
          .width(15)
      }

      Column() {
        if (index === 0) {
          this.aiItemBuilder()
        } else {
          this.tasksItemBuilder(item, index)
        }
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('48%')
      .height(180)
      .border({ width: 1, color: '#ccc', radius: 15 })
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column({ space: 15 }) {
      ForEach(RecordAndTaskViewModel.RecordAndTask,
        (item: RecordAndTaskTypeModel, index: number) => {
          this.RecAndTaskBuilder(item, index)
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}

async function checkPermissionGrant(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED

  let tokenId: number = 0
  try {
    let bundleInfo: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo
    tokenId = appInfo.accessTokenId
  } catch (error) {
    const err: BusinessError = error as BusinessError
    console.error(`Failed to get bundle info for self, code: ${err.code}, message: ${err.message}`)
  }

  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission)
  } catch (error) {
    const err: BusinessError = error as BusinessError
    console.error(`Failed to check access token, code: ${err.code}, message: ${err.message}`)
  }

  return grantStatus
}

async function checkPermissions(): Promise<boolean> {
  let grantStatus1: boolean =
    await checkPermissionGrant('ohos.permission.LOCATION') ===
    abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
  let grantStatus2: boolean =
    await checkPermissionGrant('ohos.permission.APPROXIMATELY_LOCATION') ===
    abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
  let bol: boolean = false

  return new Promise((resolve) => {
    // 精确定位权限只能跟模糊定位权限一起申请，或者已经有模糊定位权限才能申请精确定位权限。
    if (grantStatus2 && !grantStatus1) {
      // 申请精确定位权限。
      resolve(false)
    } else if (!grantStatus1 && !grantStatus2) {
      // 申请模糊定位权限与精确定位权限或单独申请模糊定位权限。
      resolve(false)
    } else {
      resolve(true)
    }
    resolve(bol)
  })
}