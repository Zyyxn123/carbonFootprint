import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { MapComponent, mapCommon, map, site } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { backButton } from "../Component/BackButton";
import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { bundleManager } from "@kit.AbilityKit";
import { JSON } from "@kit.ArkTS";
import footPriVM from "../ViewModel/FootPriViewModel";
import { PointAnnotationData, SiteItem, Type } from "../Type/FootprintMsgType";

const permissions: Permissions[] = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];

function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): Promise<boolean> {
  return new Promise((resolve) => {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    let bol = false
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: number[] = data.authResults
      let length: number = grantStatus.length
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          console.info(`${permissions[i]} is granted by user.`)
          resolve(true)
        } else {
          resolve(false)
        }
      }
    }).catch((err: BusinessError) => {
      console.error(`Failed to request permissions from user, code: ${err.code}, message: ${err.message}`)
      resolve(false)
    })
  })
}

@Component
export struct lowFootprintPage {
  @State bol: boolean = false
  @State permissionAllow: boolean = true
  @Prop val: object
  @State currIndex: number = -1
  @State isShow1: boolean = false
  @State isShow2: boolean = false
  @State isShow3: boolean = false
  @State textStr: string = ''
  private mapOptions?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  private mapEventManager?: map.MapEventManager;
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext
  private latitude: number = 0
  private longitude: number = 0
  private pointAnnotation?: map.PointAnnotation

  // 所有已添加的标注点列表（用于防重复）
  private addedAnnotations: PointAnnotationData[] = [
    {
      id: 1,
      latitude: 32.020750,
      longitude: 118.788765,
      title: '南京夫子庙(例)',
      description: '历史文化街区，低碳出行推荐地点'
    },
  ]

  @State selectedAnnotation: PointAnnotationData | null = null
  @State showAnnotationDetail: boolean = false
  @State searchResults: SiteItem[] = []
  @State isLoading: boolean = false
  @State showSearchResults: boolean = false
  @State carbonEmission: string = ''
  @State remark: string = ''
  private searchTimer: number = 0

  mapConfig() {
    this.mapOptions = {
      position: {
        target: {
          latitude: this.latitude,
          longitude: this.longitude
        },
        zoom: 10
      },
      dayNightMode: mapCommon.DayNightMode.AUTO
    }
    this.bol = true
  }

  // ====================== ✅ 核心：防重复判断 ======================
  private isAnnotationExists(lat: number, lng: number, title: string): boolean {
    // 经纬度误差小于 0.0001 视为同一个位置
    const eps = 0.0001;
    return this.addedAnnotations.some(item =>
    (Math.abs(item.latitude - lat) < eps && Math.abs(item.longitude - lng) < eps) ||
      (item.title.trim() === title.trim())
    );
  }

  checkPermission() {
    AppStorage.set('expandSafeArea', true)
    let data = (JSON.parse(JSON.stringify(this.val)) as Type).val

    if (data) {
      this.permissionAllow = true
      geoLocationManager.getCurrentLocation().then((result) => {
        this.latitude = result.latitude
        this.longitude = result.longitude
        console.info('asd current location latitude: ' + result.latitude)
        console.info('asd current location longitude: ' + result.longitude)
        this.mapConfig()
      }).catch((err: BusinessError) => {
        console.error(`getCurrentLocation failed. Code: ${err.code}, message: ${err.message}`)
      })
    } else {
      reqPermissionsFromUser(permissions, this.context).then((value) => {
        console.info(`asd: ` + value)
        if (value === true) {
          this.permissionAllow = true
          geoLocationManager.getCurrentLocation().then((result) => {
            this.latitude = result.latitude
            this.longitude = result.longitude
            console.info('asd current location latitude: ' + result.latitude)
            console.info('asd current location longitude: ' + result.longitude)
            this.mapConfig()
          }).catch((err: BusinessError) => {
            console.error(`getCurrentLocation failed. Code: ${err.code}, message: ${err.message}`)
          })
        }
      })
    }
  }

  async aboutToAppear(): Promise<void> {
    this.checkPermission()

    this.callback = async (err, mapController) => {
      if (!err) {
        this.mapController = mapController;
        this.mapEventManager = this.mapController.getEventManager();
        mapController.setZoomControlsEnabled(false)
        this.mapController.setCompassControlsEnabled(false)

        // 初始化默认标注
        for (let data of this.addedAnnotations) {
          let pointAnnotationOptions: mapCommon.PointAnnotationParams = {
            position: {
              latitude: data.latitude,
              longitude: data.longitude
            },
            repeatable: true,
            collisionRule: mapCommon.CollisionRule.NAME,
            titles: [{
              content: data.title,
              color: 0xFF000000,
              fontSize: 15,
              strokeColor: 0xFFFFFFFF,
              strokeWidth: 2,
              fontStyle: mapCommon.FontStyle.ITALIC
            }],
          }

          try {
            await this.mapController.addPointAnnotation(pointAnnotationOptions)
          } catch (e) {
            console.error(`Failed to create the pointAnnotation, code is：${e.code}, message is ${e.message}`);
          }
        }

        this.mapEventManager?.on('pointAnnotationClick', (event: map.PointAnnotation) => {
          let pos = event.getPosition();
          let clickedLat = pos.latitude;
          let clickedLon = pos.longitude;
          let foundData = this.addedAnnotations.find(data =>
          Math.abs(data.latitude - clickedLat) < 0.001 && Math.abs(data.longitude - clickedLon) < 0.001
          )
          if (foundData) {
            this.selectedAnnotation = foundData
            this.showAnnotationDetail = true
          }
        })
      }
    }
  }

  onPageShow(): void {
    if (this.mapController) {
      this.mapController.show();
    }
  }

  onPageHide(): void {
    if (this.mapController) {
      this.mapController.hide();
    }
  }

  @Builder
  FootprintBuilder() {
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
          .padding({ left: 15, right: 15, top: 10, bottom: 10 })
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
              .padding({ left: 15, right: 15, top: 10, bottom: 10 })
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
            }
            else if (this.searchResults.length > 0) {
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
            }
            else if (this.textStr.trim().length > 0) {
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

  async navigateToCurrentLocation(): Promise<void> {
    if (!this.mapController) {
      console.error('地图控制器未初始化')
      return
    }

    try {
      const result = await geoLocationManager.getCurrentLocation()
      console.info(`当前位置：纬度 ${result.latitude}, 经度 ${result.longitude}`)

      let cameraPosition: mapCommon.CameraPosition = {
        target: {
          latitude: result.latitude,
          longitude: result.longitude
        },
        zoom: 15,
        tilt: 0,
        bearing: 0
      };

      let cameraUpdate = map.newCameraPosition(cameraPosition);
      this.mapController.animateCamera(cameraUpdate, 1000);

    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`获取当前位置失败：${err.code}, ${err.message}`)

      if (this.latitude !== 0 && this.longitude !== 0) {
        console.info(`使用缓存位置：纬度 ${this.latitude}, 经度 ${this.longitude}`)

        let cameraPosition: mapCommon.CameraPosition = {
          target: {
            latitude: this.latitude,
            longitude: this.longitude
          },
          zoom: 15,
          tilt: 0,
          bearing: 0
        };

        let cameraUpdate = map.newCameraPosition(cameraPosition);
        this.mapController.animateCamera(cameraUpdate, 1000);
      }
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
        zoom: 16, tilt: 0, bearing: 0
      };
      let cameraUpdate = map.newCameraPosition(cameraPosition);
      this.mapController.animateCamera(cameraUpdate, 1000);
      return;
    }

    // 移动地图
    let cameraPosition: mapCommon.CameraPosition = {
      target: { latitude: location.latitude, longitude: location.longitude },
      zoom: 16, tilt: 0, bearing: 0
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

  @Builder
  AnnotationDetailBuilder() {
    if (this.selectedAnnotation) {
      Column({ space: 15 }) {
        Text(this.selectedAnnotation.title)
          .fontSize(20)
          .fontColor('#000')
          .fontWeight(FontWeight.Bold)

        Divider().strokeWidth(1).color('#37800f')
        Text(this.selectedAnnotation.description).fontSize(16).fontColor('#333')

        Row() {
          Text('经纬度：').fontColor('#666')
          Text(`${this.selectedAnnotation.latitude.toFixed(6)}, ${this.selectedAnnotation.longitude.toFixed(6)}`)
            .fontColor('#37800f')
        }

        Button('关闭')
          .width('100%')
          .height(40)
          .backgroundColor('#37800f')
          .fontColor('#fff')
          .onClick(() => {
            this.showAnnotationDetail = false
          })
      }
      .padding(20)
      .backgroundColor('#fff')
      .borderRadius(20)
      .shadow({ radius: 10, color: '#00000020' })
      .width('80%')
    }
  }

  @Builder
  bSBuilder(index: number) {
    if (index === 0) {
      this.FootprintBuilder()
    } else if (index === 1) {
      Text('example1')
        .fontColor('#000')
    } else if (index === 2) {
      Text('example2')
        .fontColor('#000')
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack({ alignContent: Alignment.Bottom }) {
        if (this.bol) {
          MapComponent({ mapOptions: this.mapOptions, mapCallback: this.callback })
            .width('100%')
            .height('100%')
        } else {
          if (this.permissionAllow) {
            Column({ space: 5 }) {
              LoadingProgress().width(45).color('#37800f')
              Text('地图加载中...').fontSize(20)
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#F3FEF3')
          } else {
            Column() {
              Text('请开启位置权限')
                .fontSize(20)
                .fontColor('#000')
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#F3FEF3')
          }
        }

        Row({ space: 10 }) {
          Row() {
            Text(footPriVM.tabsContent[0])
              .fontSize(17)
              .fontColor('#000')
              .fontWeight(FontWeight.Medium)
              .backgroundColor(this.currIndex === 0 ? '#37800f' : '#F3FEF3')
              .animation({ duration: 300 })
              .padding(8)
              .borderRadius(20)
              .onClick(() => {
                this.isShow1 = true
              })
              .bindSheet($$this.isShow1, this.bSBuilder(0), {
                height: 700,
                showClose: false,
                backgroundColor: '#fff',
                onWillDismiss: () => {
                  this.currIndex = -1
                  this.isShow1 = false
                  this.textStr = ''
                }
              })
            Text(footPriVM.tabsContent[1])
              .fontSize(17)
              .fontColor('#000')
              .fontWeight(FontWeight.Medium)
              .backgroundColor(this.currIndex === 1 ? '#37800f' : '#F3FEF3')
              .animation({ duration: 300 })
              .padding(8)
              .borderRadius(20)
              .onClick(() => {
                this.isShow2 = true
              })
              .bindSheet($$this.isShow2, this.bSBuilder(1), {
                height: 500,
                showClose: false,
                backgroundColor: '#fff',
                onWillDismiss: () => {
                  this.currIndex = -1
                  this.isShow2 = false
                  this.textStr = ''
                }
              })
            Text(footPriVM.tabsContent[2])
              .fontSize(17)
              .fontColor('#000')
              .fontWeight(FontWeight.Medium)
              .backgroundColor(this.currIndex === 2 ? '#37800f' : '#F3FEF3')
              .animation({ duration: 300 })
              .padding(8)
              .borderRadius(20)
              .onClick(() => {
                this.isShow3 = true
              })
              .bindSheet($$this.isShow3, this.bSBuilder(2), {
                height: 500,
                showClose: false,
                backgroundColor: '#fff',
                onWillDismiss: () => {
                  this.currIndex = -1
                  this.isShow3 = false
                  this.textStr = ''
                }
              })
          }
          .justifyContent(FlexAlign.SpaceEvenly)
          .width('70%')
          .height(50)
          .backgroundColor('#F3FEF3')
          .borderRadius(25)
          .border({ width: { bottom: 2 }, color: '#ccc' })

          Row() {
            Image($r('app.media.currLocation'))
              .width(25)
              .height(25)
              .fillColor('#FFFFFF')
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .width(50)
          .height(50)
          .backgroundColor('#37800f')
          .borderRadius(25)
          .shadow({ radius: 5, color: '#00000020', offsetX: 0, offsetY: 2 })
          .onClick(() => {
            this.navigateToCurrentLocation()
          })
          .animation({ duration: 200, curve: Curve.EaseInOut })
        }
        .padding({ bottom: 35, left: 15, right: 15 })
      }

      backButton({ pageTitle: '碳足迹', bol: this.bol })
    }
    .width('100%')
    .height('100%')
  }
}

@Builder
export function harBuilder(value: object) {
  NavDestination() {
    lowFootprintPage({ val: value })
  }
  .hideTitleBar(true)
  .title('碳足迹')
  .backgroundColor('#fff')
  .onBackPressed(() => {
    RouterModule.pop(RouterNameConstants.ENTRY_HAP)
    return true
  })
}

const builderName = BuilderNameConstants.HAR_tendency_lowFootprint
if (!RouterModule.getBuilder(builderName)) {
  const builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
  RouterModule.registerBuilder(builderName, builder)
}