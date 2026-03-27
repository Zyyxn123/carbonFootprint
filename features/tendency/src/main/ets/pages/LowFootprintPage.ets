import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { MapComponent, mapCommon, map } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { backButton } from "../Component/BackButton";
import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { bundleManager } from "@kit.AbilityKit";
import { JSON } from "@kit.ArkTS";

const permissions: Permissions[] = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];
// const twoPermissions: Permissions[] = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION']
// const onePermissions: Permissions[] = ['ohos.permission.APPROXIMATELY_LOCATION']

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
  @State permissionAllow: boolean = false
  @Prop val: object
  private TAG = "HuaweiMapDemo";
  private mapOptions?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  private mapEventManager?: map.MapEventManager;
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext
  private latitude: number = 0
  private longitude: number = 0

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

  async aboutToAppear(): Promise<void> {
    AppStorage.set('expandSafeArea', true)
    let data = (JSON.parse(JSON.stringify(this.val)) as Type).val
    console.info('lowFootprintPage3: ' + data)

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

    this.mapOptions = {
      position: {
        target: {
          latitude: 39.9,
          longitude: 116.4
        },
        zoom: 10
      }
    }

    // 地图初始化的回调
    this.callback = async (err, mapController) => {
      if (!err) {
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        this.mapEventManager = this.mapController.getEventManager();
        mapController.setZoomControlsEnabled(false)
        this.mapController.setCompassControlsEnabled(false)
        let callback = () => {
          console.info(this.TAG, `on-mapLoad`);
        }
        this.mapEventManager.on("mapLoad", callback);
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

        Row() {
          Row() {}
          .width('100%')
          .height(60)
          .backgroundColor('#fff')
          .borderRadius(30)
          .border({ width: { bottom: 2 }, color: '#ccc'})
        }
        .padding({ left: 15, right: 15, bottom: 20 })
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