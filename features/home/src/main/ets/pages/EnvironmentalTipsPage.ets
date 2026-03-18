import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter";
import { backButton } from "../Component/BackButton";
import EnvironmentalTipsViewModel from "../ViewModel/ProtectionTipsViewModel";
import { JSON } from "@kit.ArkTS";
import { HealthNewsItem } from "@ohos/utils";
import { EnvironTipsDataSource } from "../LazyFESource/EnvironTipsDataSource";
import { getHandledItemData } from "../LazyFESource/HandleData";
import { EnvironTipItemType } from "../Type/EnvironTipItemType";

/**
 * @constant 是否可以做缓存相关知识点
 */

@Component
export struct environmentalTipsPage {
  @State pageTitle: ResourceStr = $r('app.string.functionLists_environmentalEncyclopedia')
  @Prop val: object
  private dataSource: EnvironTipsDataSource = new EnvironTipsDataSource()

  aboutToAppear(): void {
    console.log('getHandledItemData: ', JSON.stringify(this.val))
    if (JSON.stringify(this.val) !== '') {
      this.dataSource.pushArray(getHandledItemData(JSON.stringify(this.val)))
    }
  }

  build() {
    Column() {
      backButton({ pageTitle: this.pageTitle })

      List() {
        LazyForEach(this.dataSource, (item: EnvironTipItemType) => {
          ListItem() {
            if (item.type === 0) {
              TextTypeItemView({ item: item })
                .reuseId('text_item_id')
                .onAppear(() => {
                  console.log('TextTypeItemView1: ' + item.title)
                })
            } else if (item.type === 1) {
              ImageTypeItemView({ item: item })
                .reuseId('image_item_id')
                .onAppear(() => {
                  console.log('TextTypeItemView2: ' + item.title)
                })
            } else if (item.type === 2) {
              ThreeImageTypeItemView({ item: item })
                .reuseId('three_image_item_id')
                .onAppear(() => {
                  console.log('TextTypeItemView3: ' + item.title)
                })
            }
          }
          .onClick(() => {
            /**
             * 跳转到另一个展示的页面
             */
          })
        }, (item: EnvironTipItemType) => item.id.toString())
      }
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .cachedCount(1)
      .width('100%')
      .height('100%')
      .padding({
        left: 10,
        right: 10,
        top: 5,
        bottom: 5
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor('#fff')
  }
}


@Builder
export function harBuilder(value: object) {
  NavDestination() {
    environmentalTipsPage({ val: value })
  }
  .hideTitleBar(true)
  .title('environmentalTipsPage')
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_home_environmentalTips
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}

@Reusable
@Component
struct TextTypeItemView {
  @ObjectLink item: EnvironTipItemType;

  build() {
    Column({ space: 25 }) {
      Text(this.item.title)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontColor('#000')
        .fontSize(16)
        .fontWeight(600)
        .margin({ left: 10, right: 10, top: 15 })
        .lineHeight(20)

      Row() {
        Text(this.item.date.split(' ')[0])
          .fontSize(15)
          .fontColor('#ffa7a7a7')

        Text(this.item.author_name)
          .fontSize(15)
          .fontColor('#000')
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ left: 10, right: 10, bottom: 15 })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height(100)
    .backgroundColor('#fff')
    .borderRadius(15)
    .margin({ top: 5, bottom: 5 })
    .border({ width: 1, color: '#ccc' })

    // .reuseId('')
  }
}


@Reusable
@Component
struct ImageTypeItemView {
  @ObjectLink item: EnvironTipItemType

  build() {
    Row({ space: 10 }) {
      Column() {
        Text(this.item.title)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor('#000')
          .fontSize(16)
          .fontWeight(600)
          .margin({
            left: 10,
            right: 10,
            top: 15,
            bottom: 10
          })
          .lineHeight(20)
          .width('100%')

        Row() {
          Text(this.item.date.split(' ')[0])
            .fontSize(15)
            .fontColor('#ffa7a7a7')

          Text(this.item.author_name)
            .fontSize(15)
            .fontColor('#000')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ left: 10, right: 10, bottom: 15 })
      }
      .width('50%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceBetween)

      Image(this.item.thumbnail_pic_s)
        .width(120)
        .height(80)
        .borderRadius(15)
        .objectFit(ImageFit.Fill)
        .margin({ right: 20 })
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(100)
    .backgroundColor('#fff')
    .borderRadius(15)
    .margin({ top: 5, bottom: 5 })
    .border({ width: 1, color: '#ccc' })
    .reuseId('image_item_id')
  }
}

@Reusable
@Component
struct ThreeImageTypeItemView {
  @ObjectLink item: EnvironTipItemType

  build() {
    Column({ space: 10 }) {
      Text(this.item.title)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontColor('#000')
        .fontSize(16)
        .fontWeight(600)
        .margin({ left: 10, right: 10, top: 15 })
        .lineHeight(20)

      if (this.item.thumbnail_pic_s03?.trim() !== '') {
        threeImageLayer(this.item)
      } else {
        twoImageLayer(this.item)
      }

      Row() {
        Text(this.item.date.split(' ')[0])
          .fontSize(15)
          .fontColor('#ffa7a7a7')

        Text(this.item.author_name)
          .fontSize(15)
          .fontColor('#000')
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ left: 10, right: 10, bottom: 15 })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height(180)
    .backgroundColor('#fff')
    .borderRadius(15)
    .margin({ top: 5, bottom: 5 })
    .border({ width: 1, color: '#ccc' })
  }
}

@Builder
function threeImageLayer(item: EnvironTipItemType) {
  Row({ space: 4 }) {
    Image(item.thumbnail_pic_s)
      .width(100)
      .height(90)
      .objectFit(ImageFit.Fill)
      .borderRadius({ topLeft: 15, bottomLeft: 15 })
      .border({ width: { left: 1 }, color: '#ccc' })
    Image(item.thumbnail_pic_s02)
      .width(100)
      .height(90)
      .objectFit(ImageFit.Fill)
      .border({ width: { left: 1 }, color: '#ccc' })
    Image(item.thumbnail_pic_s03)
      .width(100)
      .height(90)
      .objectFit(ImageFit.Fill)
      .borderRadius({ topRight: 15, bottomRight: 15 })
      .border({ width: { right: 1 }, color: '#ffececec' })
  }
  .width('100%')
  .padding({ left: 20, right: 30 })
}

@Builder
function twoImageLayer(item: EnvironTipItemType) {
  Row({ space: 4 }) {
    Image(item.thumbnail_pic_s)
      .width(140)
      .height(100)
      .objectFit(ImageFit.Fill)
      .borderRadius({ topLeft: 15, bottomLeft: 15 })
      .border({ width: { left: 1 }, color: '#ccc' })
    Image(item.thumbnail_pic_s02)
      .width(140)
      .height(100)
      .objectFit(ImageFit.Fill)
      .borderRadius({ topRight: 15, bottomRight: 15 })
      .border({ width: { right: 1 }, color: '#ffececec' })
  }
  .width('100%')
  .padding({ left: 30, right: 30 })
  .justifyContent(FlexAlign.Center)
}