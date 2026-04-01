import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { MapComponent, mapCommon, map, site } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { backButton } from "../Component/BackButton";
import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from "@kit.ArkTS";
import footPriVM from "../ViewModel/FootPriViewModel";
import {
  PointAnnotationData,
  SiteItem,
  Type,
  TransportType,
  TransportOption,
  TrackInfo,
  Location,
  TrackRecord
} from "../Type/FootprintMsgType";
import { promptAction } from "@kit.ArkUI";
import { MapFootprintView } from "../View/MapFootprintView";
import { MapTrackView } from "../View/MapTrackView";

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
  @State myShowResults: boolean = true
  @State makeSureToQuit: boolean = true
  @State canMark: boolean = false
  @State currData: SiteItem | undefined = undefined
  // 碳足迹


  @State footprintSelectedData: SiteItem | undefined = undefined
  @State bol: boolean = false
  @State permissionAllow: boolean = true
  @Prop val: object
  @State currIndex: number = -1
  @State isShow1: boolean = false
  @State isShow2: boolean = false
  @State isShow3: boolean = false
  @State textStr: string = ''
  @State selectedAnnotation: PointAnnotationData | null = null
  @State showAnnotationDetail: boolean = false
  @State searchResults: SiteItem[] = []
  @State isLoading: boolean = false
  @State showSearchResults: boolean = false
  @State carbonEmission: string = ''
  @State remark: string = ''
  // 碳轨迹相关状态变量
  @State startPoint: Location | null = null
  @State endPoint: Location | null = null
  @State startPointText: string = ''
  @State endPointText: string = ''
  @State selectingPoint: 'start' | 'end' | null = null
  @State showPointSelectionHint: boolean = false
  @State selectedTransport: TransportType = TransportType.DRIVING
  @State trackInfo: TrackInfo = {
    distance: 0,
    carbonEmission: 0,
    estimatedTime: 0,
    transportType: TransportType.DRIVING
  }
  @State transportOptions: TransportOption[] = [
    { value: TransportType.WALKING, label: '步行', icon: $r('app.media.currLocation') }, // $r('app.media.map_pin')
    { value: TransportType.CYCLING, label: '骑行', icon: $r('app.media.currLocation') }, // $r('app.media.map_pin')
    { value: TransportType.DRIVING, label: '驾车', icon: $r('app.media.currLocation') }, // $r('app.media.map_pin')
    {
      value: TransportType.PUBLIC_TRANSPORT,
      label: '公共交通',
      icon: $r('app.media.currLocation')
    }// $r('app.media.map_pin')
  ]
  // 起点/终点搜索相关状态
  @State startSearchResults: SiteItem[] = []
  @State endSearchResults: SiteItem[] = []
  @State showStartSearchResults: boolean = false
  @State showEndSearchResults: boolean = false
  @State startSearchLoading: boolean = false
  @State endSearchLoading: boolean = false
  @State startSearchTimer: number = 0
  @State endSearchTimer: number = 0
  private mapArc?: map.MapArc
  private mapOptions?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  @StorageLink('mapCtr') mapController: map.MapComponentController | undefined = undefined
  private mapEventManager?: map.MapEventManager;
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext
  private latitude: number = 0
  private longitude: number = 0
  private pointAnnotation?: map.PointAnnotation
  private addedAnnotations: PointAnnotationData[] = [
    {
      id: 1,
      latitude: 32.020750,
      longitude: 118.788765,
      title: '南京夫子庙(例)',
      description: '历史文化街区，低碳出行推荐地点'
    },
  ]
  public searchTimer: number = 0

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

  private isAnnotationExists(lat: number, lng: number, title: string): boolean {
    // 经纬度误差小于 0.0001 视为同一个位置
    const eps = 0.0001;
    return this.addedAnnotations.some(item =>
    (Math.abs(item.latitude - lat) < eps && Math.abs(item.longitude - lng) < eps) ||
      (item.title.trim() === title.trim())
    );
  }

  // 碳轨迹计算函数
  private calculateDistance(): void {
    if (!this.startPoint || !this.endPoint) {
      return;
    }

    const R = 6371; // 地球半径（公里）
    const lat1 = this.startPoint.latitude * Math.PI / 180;
    const lat2 = this.endPoint.latitude * Math.PI / 180;
    const deltaLat = (this.endPoint.latitude - this.startPoint.latitude) * Math.PI / 180;
    const deltaLon = (this.endPoint.longitude - this.startPoint.longitude) * Math.PI / 180;

    const a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
      Math.cos(lat1) * Math.cos(lat2) *
      Math.sin(deltaLon / 2) * Math.sin(deltaLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    const distance = R * c;
    this.trackInfo.distance = distance;

    // 根据交通方式计算预计时间
    this.calculateEstimatedTime(distance);
  }

  private calculateEstimatedTime(distance: number): void {
    const speedFactors: Record<TransportType, number> = {
      [TransportType.WALKING]: 5, // 步行：5 km/h
      [TransportType.CYCLING]: 15, // 骑行：15 km/h
      [TransportType.DRIVING]: 40, // 驾车：40 km/h（城市平均）
      [TransportType.PUBLIC_TRANSPORT]: 20 // 公共交通：20 km/h（含等待时间）
    };

    const speed = speedFactors[this.selectedTransport];
    const timeInHours = distance / speed;
    this.trackInfo.estimatedTime = Math.round(timeInHours * 60); // 转换为分钟
  }

  private calculateCarbonEmission(): void {
    if (this.trackInfo.distance === 0) {
      return;
    }

    const emissionFactors: Record<TransportType, number> = {
      [TransportType.WALKING]: 0, // 步行无碳排放
      [TransportType.CYCLING]: 0, // 骑行无碳排放
      [TransportType.DRIVING]: 0.12, // 驾车：0.12 kg CO2/km
      [TransportType.PUBLIC_TRANSPORT]: 0.05 // 公共交通：0.05 kg CO2/km
    };

    const factor = emissionFactors[this.selectedTransport];
    this.trackInfo.carbonEmission = this.trackInfo.distance * factor;
    this.trackInfo.transportType = this.selectedTransport;
  }

  private setupMapClickHandler(): void {
    this.mapEventManager?.on('mapClick', (event) => {
      if (this.selectingPoint && this.showPointSelectionHint) {
        const clickedLocation: Location = {
          latitude: event.latitude,
          longitude: event.longitude
        };

        if (this.selectingPoint === 'start') {
          this.startPoint = clickedLocation;
          this.startPointText = `${clickedLocation.latitude.toFixed(6)}, ${clickedLocation.longitude.toFixed(6)}`;
          // 隐藏起点搜索结果
          this.showStartSearchResults = false;
          // 添加起点标注
          this.addTrackPointAnnotation(clickedLocation, '起点', '#37800f');
        } else if (this.selectingPoint === 'end') {
          this.endPoint = clickedLocation;
          this.endPointText = `${clickedLocation.latitude.toFixed(6)}, ${clickedLocation.longitude.toFixed(6)}`;
          // 隐藏终点搜索结果
          this.showEndSearchResults = false;
          // 添加终点标注
          this.addTrackPointAnnotation(clickedLocation, '终点', '#d95011');
        }

        this.selectingPoint = null;
        this.showPointSelectionHint = false;

        // 如果起点和终点都已选择，计算距离和碳排放
        if (this.startPoint && this.endPoint) {
          this.calculateDistance();
          this.calculateCarbonEmission();
        }
      }
    });
  }

  private addTrackPointAnnotation(location: Location, title: string, color: string): void {
    if (!this.mapController) {
      return;
    }

    const pointAnnotationOptions: mapCommon.PointAnnotationParams = {
      position: {
        latitude: location.latitude,
        longitude: location.longitude
      },
      repeatable: true,
      collisionRule: mapCommon.CollisionRule.NAME,
      titles: [{
        content: title,
        color: this.hexToArgb(color),
        fontSize: 16,
        strokeColor: 0xFFFFFFFF,
        strokeWidth: 2,
        fontStyle: mapCommon.FontStyle.ITALIC
      }],
    };

    try {
      this.mapController.addPointAnnotation(pointAnnotationOptions);
      console.info(`已添加轨迹点标注：${title}`);
    } catch (e) {
      console.error(`添加轨迹点标注失败：${e.code}, ${e.message}`);
    }
  }

  private hexToArgb(hexColor: string): number {
    // 将 #RRGGBB 转换为 ARGB 整数
    const hex = hexColor.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);
    return (0xFF << 24) | (r << 16) | (g << 8) | b;
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

        // 添加地图点击事件监听（用于碳轨迹选点）
        this.setupMapClickHandler()
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

  // 额外信息
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

  // 判断是哪个按钮
  @Builder
  bSBuilder(index: number) {
    if (index === 0) {
      MapFootprintView({
        isShow1: this.isShow1,
        textStr: this.textStr,
        footprintSelectedData: this.footprintSelectedData,
        myShowResults: this.myShowResults,
        makeSureToQuit: this.makeSureToQuit,
        canMark: this.canMark,
        currData: this.currData,
      })
    } else if (index === 1) {
      MapTrackView()
    } else if (index === 2) {
      // MapPlanView()
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack({ alignContent: Alignment.Bottom }) {
        if (this.bol) {
          // 地图
          MapComponent({ mapOptions: this.mapOptions, mapCallback: this.callback })
            .width('100%')
            .height('100%')
        } // 地图未显示时：开启权限或加载
        else {
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

        // 三个按钮
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
                height: 500,
                showClose: false,
                backgroundColor: '#fff',
                onWillDismiss: () => {
                  this.currIndex = -1
                  this.isShow1 = false
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
                height: 700,
                showClose: false,
                backgroundColor: '#fff',
                onWillDismiss: () => {
                  this.currIndex = -1
                  this.isShow2 = false
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
                }
              })
          }
          .justifyContent(FlexAlign.SpaceEvenly)
          .width('70%')
          .height(50)
          .backgroundColor('#F3FEF3')
          .borderRadius(25)
          .border({ width: { bottom: 2 }, color: '#ccc' })

          // 定位自己的位置
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
          .shadow({
            radius: 5,
            color: '#00000020',
            offsetX: 0,
            offsetY: 2
          })
          .onClick(() => {
            this.navigateToCurrentLocation()
          })
          .animation({ duration: 200, curve: Curve.EaseInOut })
        }
        .padding({ bottom: 35, left: 15, right: 15 })
      }

      // 返回
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