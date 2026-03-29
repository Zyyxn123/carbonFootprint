import { PointAnnotationData, SiteItem } from "../Type/FootprintMsgType"
import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { MapComponent, mapCommon, map, site } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { backButton } from "../Component/BackButton";
import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from "@kit.ArkTS";


@Component
export struct MapFootprintView {
  @State isShow1: boolean = false
  @State showSearchResults: boolean = false
  @State isLoading: boolean = false
  @State showAnnotationDetail: boolean = false
  @State textStr: string = ''
  @State carbonEmission: string = ''
  @State remark: string = ''
  @State searchResults: SiteItem[] = []
  @State selectedAnnotation: PointAnnotationData | null = null
  @StorageLink('mapCtr') mapController: map.MapComponentController | undefined = undefined
  private searchTimer: number = 0
  private addedAnnotations: PointAnnotationData[] = [
    {
      id: 1,
      latitude: 32.020750,
      longitude: 118.788765,
      title: '南京夫子庙(例)',
      description: '历史文化街区，低碳出行推荐地点'
    },
  ]

  private isAnnotationExists(lat: number, lng: number, title: string): boolean {
    // 经纬度误差小于 0.0001 视为同一个位置
    const eps = 0.0001;
    return this.addedAnnotations.some(item =>
    (Math.abs(item.latitude - lat) < eps && Math.abs(item.longitude - lng) < eps) ||
      (item.title.trim() === title.trim())
    );
  }

  async performSearch(query: string): Promise<void> {
    if (!query.trim()) {
      this.searchResults = []
      this.showSearchResults = false
      return
    }

    this.isLoading = true
    this.showSearchResults = true

    let params: site.SearchByTextParams = {
      query: query,
      language: "zh_CN"
    }

    try {
      const result = await site.searchByText(params)
      console.info(`搜索结果：${JSON.stringify(result)}`)
      this.searchResults = result.sites as SiteItem[]
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`搜索失败：${err.code}, ${err.message}`)
      this.searchResults = []
    } finally {
      this.isLoading = false
    }
  }

  async navigateToSite(siteItem: SiteItem): Promise<void> {
    if (!this.mapController || !siteItem.location) {
      return
    }

    const location = siteItem.location
    const title = siteItem.name ?? '未知地点'

    // ====================== ✅ 防重复：存在就不添加 ======================
    if (this.isAnnotationExists(location.latitude, location.longitude, title)) {
      console.info('该地点已存在标注，不再重复添加');

      // 仅移动地图
      let cameraPosition: mapCommon.CameraPosition = {
        target: { latitude: location.latitude, longitude: location.longitude },
        zoom: 16,
        tilt: 0,
        bearing: 0
      };
      let cameraUpdate = map.newCameraPosition(cameraPosition);
      this.mapController.animateCamera(cameraUpdate, 1000);
      return;
    }

    // 移动地图
    let cameraPosition: mapCommon.CameraPosition = {
      target: { latitude: location.latitude, longitude: location.longitude },
      zoom: 16,
      tilt: 0,
      bearing: 0
    };
    let cameraUpdate = map.newCameraPosition(cameraPosition);
    this.mapController.animateCamera(cameraUpdate, 1000);

    // 添加标注
    let pointAnnotationOptions: mapCommon.PointAnnotationParams = {
      position: { latitude: location.latitude, longitude: location.longitude },
      repeatable: true,
      collisionRule: mapCommon.CollisionRule.NAME,
      titles: [{
        content: title,
        color: 0xFF37800f,
        fontSize: 16,
        strokeColor: 0xFFFFFFFF,
        strokeWidth: 2,
        fontStyle: mapCommon.FontStyle.ITALIC
      }],
    }

    try {
      await this.mapController.addPointAnnotation(pointAnnotationOptions)
      console.info(`已添加标注：${title}`)

      // ✅ 加入已添加列表，防止重复
      this.addedAnnotations.push({
        id: Date.now(),
        latitude: location.latitude,
        longitude: location.longitude,
        title: title,
        description: siteItem.formatAddress || '无详细地址',
        iconColor: '#37800f'
      })
    } catch (e) {
      console.error(`添加标注失败`)
    }

    this.showSearchResults = false
    this.textStr = siteItem.name ?? ''

    this.selectedAnnotation = {
      id: Date.now(),
      latitude: location.latitude,
      longitude: location.longitude,
      title: title,
      description: siteItem.formatAddress || '无详细地址',
      iconColor: '#37800f'
    }
    this.showAnnotationDetail = true
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('碳足迹')
          .fontSize(20)
          .fontColor('#000')
          .fontWeight(FontWeight.Medium)

        Image($r('app.media.arrow_up'))
          .rotate({ angle: 180 })
          .fillColor('#000')
          .padding(10)
          .borderRadius(20)
          .width(35)
          .margin({ right: 10 })
          .backgroundColor('#ffe3e3e3')
          .height(35)
          .onClick(() => {
            this.isShow1 = false
            this.textStr = ''
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Column({ space: 10 }) {
        Row() {
          TextInput({ placeholder: '搜索地点...', text: $$this.textStr })
            .width('75%')
            .fontColor('#000')
            .placeholderColor('#ccc')
            .backgroundColor(Color.Transparent)
            .onChange((value: string) => {
              this.textStr = value
              if (this.searchTimer) {
                clearTimeout(this.searchTimer)
              }
              this.searchTimer = setTimeout(() => {
                this.performSearch(value)
              }, 500) as number
            })

          Divider()
            .vertical(true)
            .color('#81B29A')
            .width(2)
            .height(30)
            .strokeWidth(2)
            .margin({ left: 5, right: 10 })

          Image($r('app.media.map_search'))
            .width(30)
            .fillColor('#37800f')
            .margin({ right: 5 })
            .onClick(() => {
              this.performSearch(this.textStr)
            })
            .animation({ duration: 200, curve: Curve.EaseInOut })
        }
        .border({ width: 2, color: '#81B29A', radius: 20 })
        .padding({ left: 15, right: 10 })
        .backgroundColor('#F3FEF3')

        Column({ space: 10 }) {
          Text('碳排放数据 (可选)')
            .fontSize(14)
            .fontColor('#37800f')
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)
            .margin({ bottom: 5 })

          Row() {
            TextInput({ placeholder: '请输入碳排放量，单位：千克', text: $$this.carbonEmission })
              .width('85%')
              .fontColor('#000')
              .placeholderColor('#999')
              .backgroundColor(Color.Transparent)
              .onChange((value: string) => {
                this.carbonEmission = value
              })

            Text('kg')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ left: 10 })
          }
          .border({ width: 1, color: '#81B29A', radius: 12 })
          .padding({
            left: 15,
            right: 15,
            top: 10,
            bottom: 10
          })
          .backgroundColor('#F9FFFD')

          Column({ space: 5 }) {
            Text('备注信息 (可选)')
              .fontSize(14)
              .fontColor('#37800f')
              .fontWeight(FontWeight.Medium)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 5 })

            TextInput({ placeholder: '请输入相关备注信息', text: $$this.remark })
              .width('100%')
              .fontColor('#000')
              .placeholderColor('#999')
              .backgroundColor('#FFFFFF')
              .border({ width: 1, color: '#81B29A', radius: 12 })
              .padding({
                left: 15,
                right: 15,
                top: 10,
                bottom: 10
              })
              .onChange((value: string) => {
                this.remark = value
              })
          }
          .width('100%')
        }
        .width('100%')
        .margin({ top: 20 })

        if (this.showSearchResults) {
          Column({ space: 5 }) {
            if (this.isLoading) {
              Row() {
                LoadingProgress().width(25).height(25).color('#37800f')
                Text('搜索中...').fontSize(14).fontColor('#666666').margin({ left: 10 })
              }
              .width('100%')
              .padding(15)
              .justifyContent(FlexAlign.Center)
            } else if (this.searchResults.length > 0) {
              Column({ space: 8 }) {
                Text(`找到 ${this.searchResults.length} 个结果`)
                  .fontSize(14)
                  .fontColor('#37800f')
                  .fontWeight(FontWeight.Medium)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .padding({ left: 5, bottom: 5 })

                Scroll() {
                  Column({ space: 5 }) {
                    ForEach(this.searchResults, (item: SiteItem, index: number) => {
                      Column() {
                        Row() {
                          Column({ space: 2 }) {
                            Text(item.name ?? '未知地点')
                              .fontSize(16)
                              .fontColor('#000000')
                              .fontWeight(FontWeight.Medium)
                              .maxLines(1)
                              .textOverflow({ overflow: TextOverflow.Ellipsis })

                            if (item.formatAddress) {
                              Text(item.formatAddress)
                                .fontSize(13)
                                .fontColor('#666666')
                                .maxLines(1)
                                .textOverflow({ overflow: TextOverflow.Ellipsis })
                            }
                          }
                          .width('90%')

                          Image($r('app.media.arrow_up'))
                            .rotate({ angle: 90 })
                            .width(20)
                            .fillColor('#37800f')
                            .opacity(0.7)
                        }
                        .width('100%')
                        .padding(12)
                        .backgroundColor('#FFFFFF')
                        .borderRadius(12)
                        .shadow({
                          radius: 3,
                          color: '#00000010',
                          offsetX: 0,
                          offsetY: 2
                        })
                        .onClick(() => {
                          this.isShow1 = false
                          this.textStr = ''
                          this.navigateToSite(item)
                        })
                        .animation({ duration: 200, curve: Curve.EaseInOut })

                        if (index < this.searchResults.length - 1) {
                          Divider().strokeWidth(1).color('#E0E0E0')
                        }
                      }
                    })
                  }
                  .width('100%')
                }
                .width('100%')
                .height(250)
              }
              .width('100%')
              .padding(5)
              .backgroundColor('#FFFFFF')
              .borderRadius(15)
              .shadow({
                radius: 10,
                color: '#00000020',
                offsetX: 0,
                offsetY: 5
              })
            } else if (this.textStr.trim().length > 0) {
              Row() {
                Text('未找到相关地点').fontSize(14).fontColor('#999999')
              }
              .width('100%')
              .padding(20)
              .justifyContent(FlexAlign.Center)
              .backgroundColor('#FFFFFF')
              .borderRadius(15)
            }
          }
          .width('100%')
          .border({ width: 1, color: '#ccc', radius: 15 })
        }
      }
      .width('100%')
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 20 })
  }
}