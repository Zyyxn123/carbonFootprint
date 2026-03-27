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


const permissions: Permissions[] = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];

function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): Promise<boolean> {
  return new Promise((resolve) => {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    let bol = false
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: number[] = data.authResults
      let length: number = grantStatus.length
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // 用户授权，可以继续访问目标操作
          console.info(`${permissions[i]} is granted by user.`)
          resolve(true)
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          resolve(false)
        }
      }
    }).catch((err: BusinessError) => {
      console.error(`Failed to request permissions from user, code: ${err.code}, message: ${err.message}`)
    })
  })
}

@Component
export struct lowFootprintPage {
  @State bol: boolean = false
  @State permissionAllow: boolean = true
  @Prop val: object
  @State currIndex: number = -1
  @State isShow: boolean = false
  @State textStr: string = ''
  private TAG = "HuaweiMapDemo";
  private mapOptions?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  private mapEventManager?: map.MapEventManager;
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext
  private latitude: number = 0
  private longitude: number = 0
  private pointAnnotation?: map.PointAnnotation

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
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        this.mapEventManager = this.mapController.getEventManager();
        mapController.setZoomControlsEnabled(false)
        this.mapController.setCompassControlsEnabled(false)
        let pointAnnotationOptions: mapCommon.PointAnnotationParams = {
          position: {
            latitude: 32.020750,
            longitude: 118.788765
          },
          repeatable: true,
          collisionRule: mapCommon.CollisionRule.NAME,
          titles: [{
            // 定义标题内容
            content: "南京夫子庙",
            // 定义标题字体颜色
            color: 0xFF000000,
            // 定义标题字体大小
            fontSize: 15,
            // 定义标题描边颜色
            strokeColor: 0xFFFFFFFF,
            // 定义标题描边宽度
            strokeWidth: 2,
            // 定义标题字体样式
            fontStyle: mapCommon.FontStyle.ITALIC
          }],
        }

        try {
          this.pointAnnotation = await this.mapController.addPointAnnotation(pointAnnotationOptions)
        } catch (e) {
          console.error(`Failed to create the pointAnnotation, code is：${e.code}, message is ${e.message}`);
        }
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
        Image($r('app.media.arrow_up'))
          .rotate({
            angle: 180
          })
          .fillColor('#000')
          .padding(10)
          .borderRadius(20)
          .width(35)
          .margin({ right: 10 })
          .backgroundColor('#ffe3e3e3')
          .height(35)
          .onClick(() => {
            this.isShow = false
          })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')

      Row() {
        TextInput({ placeholder: '请输入', text: $$this.textStr })
          .width('70%')
          .backgroundColor(Color.Transparent)
        Divider()
          .vertical(true)
          .color('#ccc')
          .width(3)
          .height(30)
          .strokeWidth(2)
          .margin({ left: 5, right: 10 })
        Image($r('app.media.map_search'))
          .width(30)
          .fillColor('#ccc')
          .margin({ right: 5 })
          .onClick(async () => {
            let params: site.SearchByTextParams = {
              query: this.textStr,
              language: "zh_CN"
            }
            try {
              const result = await site.searchByText(params)
              console.info(`Succeeded in searching by text. result is ${JSON.stringify(result)}`)

              if (result.sites && result.sites.length > 0) {
                for (let index = 0; index < result.sites.length; index++) {
                  const siteItem = result.sites[index];

                  console.info(`datas: ${index}siteId: ` + siteItem.siteId);
                  console.info(`datas: ${index}name: ` + siteItem.name);
                  console.info(`datas: ${index}formatAddress: ` + siteItem.formatAddress);
                  // console.info(`1111111111distance: ` + siteItem.distance);
                  console.info(`datas: ${index}atitude: ` + siteItem.location?.latitude);
                  console.info(`datas: ${index}longitude: ` + siteItem.location?.longitude);
                  // console.info(`1111111111viewport northeast latitude: ` + siteItem.viewport?.northeast.latitude);
                  // console.info(`1111111111viewport northeast longitude: ` + siteItem.viewport?.northeast.longitude);
                  // console.info(`1111111111viewport southwest latitude: ` + siteItem.viewport?.southwest.latitude);
                  // console.info(`1111111111viewport southwest longitude: ` + siteItem.viewport?.southwest.longitude);
                  // console.info(`1111111111countryName: ` + siteItem.addressComponent.countryName);
                  // console.info(`1111111111countryCode: ` + siteItem.addressComponent.countryCode);
                  // console.info(`1111111111adminLevel1: ` + siteItem.addressComponent.adminLevel1);
                  // console.info(`1111111111adminLevel2: ` + siteItem.addressComponent.adminLevel2);
                  // console.info(`1111111111adminLevel3: ` + siteItem.addressComponent.adminLevel3);
                  // console.info(`1111111111adminLevel4: ` + siteItem.addressComponent.adminLevel4);
                  // console.info(`1111111111adminCode: ` + siteItem.addressComponent.adminCode);
                  // console.info(`1111111111cityCode: ` + siteItem.addressComponent.city?.cityCode);
                  // console.info(`1111111111cityId: ` + siteItem.addressComponent.city?.cityId);
                  // console.info(`1111111111cityName: ` + siteItem.addressComponent.city?.cityName);
                  // console.info(`1111111111streetNumber: ` + siteItem.addressComponent.streetNumber?.streetNumber);
                  // console.info(`1111111111streetName: ` + siteItem.addressComponent.streetNumber?.streetName);
                }
              }
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              console.error(`Failed in searching by text. Code is ${err.code}, message is ${err.message}`)
            }
          })
      }
      .border({ width: 2, color: '#ccc', radius: 15 })
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 20 })
  }

  @Builder
  bSBuilder(index: number) {
    if (index === 0) {
      this.FootprintBuilder()
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack({ alignContent: Alignment.Bottom }) {
        if (this.bol) {
          MapComponent({ mapOptions: this.mapOptions, mapCallback: this.callback }).width('100%').height('100%')
        } else {
          if (this.permissionAllow) {
            Column({ space: 5 }) {
              LoadingProgress()
                .width(45)
                .color('#37800f')
              Text('地图正在加载中...')
                .fontSize(20)
                .fontColor('#000')
            }
            .width('100%')
            .height('100%')
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
          } else {
            Column({ space: 5 }) {
              Text('请前往设置开启精确位置权限')
                .fontSize(20)
                .fontColor('#000')
            }
            .width('100%')
            .height('100%')
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
          }
        }

        Row({ space: 10 }) {
          Row() {
            ForEach(footPriVM.tabsContent, (item: string, index: number) => {
              Text(item)
                .fontSize(17)
                .fontColor('#000')
                .fontWeight(FontWeight.Medium)
                .backgroundColor(this.currIndex === index ? '#37800f' : '#fff')
                .padding(8)
                .borderRadius(20)
                .onClick(() => {
                  if (this.currIndex === index) {
                    this.currIndex = -1
                  } else {
                    this.currIndex = index
                  }
                  this.isShow = true
                })
                .bindSheet($$this.isShow, this.bSBuilder(index), {
                  height: 500,
                  showClose: false,
                  backgroundColor: '#fff',
                  borderColor: '#ccc',
                  onWillDismiss: () => {
                    this.isShow = false
                  },
                  onWillAppear: () => {
                    this.isShow = true
                  }
                })
            })
          }
          .justifyContent(FlexAlign.SpaceEvenly)
          .padding(8)
          .width('80%')
          .height(50)
          .backgroundColor('#fff')
          .borderRadius(25)
          .border({ width: { bottom: 2, left: 1, right: 1 }, color: '#ccc' })
          .zIndex(9)

          // Row() {
          //   Image($r('app.media.arrow_up'))
          //     .width(45)
          //     .fillColor('#000')
          // }
          // .backgroundColor('#fff')
          // .width(45)
          // .height(45)
          // .borderRadius(22)
          // .padding(8)
          // .alignItems(VerticalAlign.Center)
          // .justifyContent(FlexAlign.Center)
        }
        .padding({ left: 15, right: 15, bottom: 35 })
      }
      .width('100%')
      .height('100%')

      backButton({ pageTitle: '碳足迹', bol: this.bol })
    }
    .height('100%')
    .width('100%')
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

interface Type {
  val: boolean
}
// 坐标经纬度
export interface Location {
  latitude: number;
  longitude: number;
}

// 视图边界
export interface Viewport {
  northeast: Location;
  southwest: Location;
}

// 城市信息
export interface City {
  cityCode: string;
  cityId: string;
  cityName: string;
}

// 街道门牌号
export interface StreetNumber {
  streetNumber: string;
  streetName: string;
}

// 地址组件
export interface AddressComponent {
  countryName: string;
  countryCode: string;
  adminLevel1: string;
  adminLevel2: string;
  adminLevel3: string;
  adminLevel4: string;
  adminCode: string;
  city: City;
  streetNumber: StreetNumber;
}

// 时间点定义（修复点1）
export interface TimePoint {
  week: number;
  time: string;
}

// 营业时间时段（修复点2）
export interface OpeningPeriod {
  open: TimePoint;
  close: TimePoint;
}

// 营业时间
export interface OpeningHours {
  texts: string[];
  periods: OpeningPeriod[];
}

// POI 评论评分
export interface PoiComment {
  averageRating: number;
  total?: number;
}

// POI 详情
export interface PoiInfo {
  poiTypes: string[];
  poiTypeIds: string[];
  phone: string;
  internationalPhone: string;
  rating: number;
  openingHours: Partial<OpeningHours>;
  businessStatus: string;
  brand?: string;
  starRating: number;
  icon: string;
  comment: PoiComment;
}

// 单个地点（点位）
export interface SiteItem {
  siteId: string;
  name: string;
  formatAddress: string;
  addressComponent: AddressComponent;
  location: Location;
  viewport: Viewport;
  distance: number;
  poi: PoiInfo;
}

// 搜索接口完整返回结果
export interface SiteSearchResponse {
  totalCount: number;
  sites: SiteItem[];
}