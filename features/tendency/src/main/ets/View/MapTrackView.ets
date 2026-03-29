import { BuilderNameConstants, RouterModule, RouterNameConstants } from "@ohos/customrouter"
import { MapComponent, mapCommon, map, site } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { backButton } from "../Component/BackButton";
import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from "@kit.ArkTS";
import {
  Location,
  PointAnnotationData,
  SiteItem,
  TrackInfo,
  TrackRecord,
  TransportOption,
  TransportType
} from "../Type/FootprintMsgType";

@Component
export struct MapTrackView {
  @State isShow2: boolean = false
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
  @StorageLink('mapCtr') mapController: map.MapComponentController | undefined = undefined
  private mapArc?: map.MapArc

  private async clearTrack(): Promise<void> {
    try {
      // 清除弧线
      await this.clearTrackArc();

      // 清除轨迹点标注（可以扩展）
      // await this.clearTrackPointAnnotations();

      // 重置状态
      this.startPoint = null;
      this.endPoint = null;
      this.startPointText = '';
      this.endPointText = '';
      this.trackInfo = {
        distance: 0,
        carbonEmission: 0,
        estimatedTime: 0,
        transportType: TransportType.DRIVING
      };

    } catch (error) {
      console.error(`清除轨迹失败：${error.code}, ${error.message}`);
    }
  }

  private async clearTrackArc(): Promise<void> {
    if (this.mapController && this.mapArc) {
      try {
        /*await */
        this.mapController.clear() /*removeArc(this.currentArc);*/
      } catch (error) {
        console.error(`清除弧线失败：${error.code}, ${error.message}`);
      }
    }
  }
  // 通用搜索函数
  private async performSearchForInput(query: string, type: 'start' | 'end'): Promise<void> {
    if (!query.trim()) {
      if (type === 'start') {
        this.startSearchResults = []
        this.showStartSearchResults = false
      } else {
        this.endSearchResults = []
        this.showEndSearchResults = false
      }
      return
    }

    // 设置加载状态
    if (type === 'start') {
      this.startSearchLoading = true
      this.showStartSearchResults = true
    } else {
      this.endSearchLoading = true
      this.showEndSearchResults = true
    }

    let params: site.SearchByTextParams = {
      query: query,
      language: "zh_CN"
    }

    try {
      const result = await site.searchByText(params)
      console.info(`搜索结果(${type})：${JSON.stringify(result)}`)

      if (type === 'start') {
        this.startSearchResults = result.sites as SiteItem[]
      } else {
        this.endSearchResults = result.sites as SiteItem[]
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`搜索失败(${type})：${err.code}, ${err.message}`)
      if (type === 'start') {
        this.startSearchResults = []
      } else {
        this.endSearchResults = []
      }
    } finally {
      if (type === 'start') {
        this.startSearchLoading = false
      } else {
        this.endSearchLoading = false
      }
    }
  }

  // 起点搜索函数
  private performStartSearch(query: string): void {
    if (this.startSearchTimer) {
      clearTimeout(this.startSearchTimer)
    }
    this.startSearchTimer = setTimeout(() => {
      this.performSearchForInput(query, 'start')
    }, 500) as number
  }

  // 终点搜索函数
  private performEndSearch(query: string): void {
    if (this.endSearchTimer) {
      clearTimeout(this.endSearchTimer)
    }
    this.endSearchTimer = setTimeout(() => {
      this.performSearchForInput(query, 'end')
    }, 500) as number
  }

  // 处理起点搜索结果选择
  private handleStartSearchResultSelected(item: SiteItem): void {
    if (!item.location) {
      return
    }

    // 设置起点位置
    this.startPoint = item.location
    this.startPointText = item.name || `${item.location.latitude.toFixed(6)}, ${item.location.longitude.toFixed(6)}`

    // 移动到该位置
    this.moveToLocation(item.location)

    // 隐藏搜索结果
    this.showStartSearchResults = false

    // 添加起点标注
    this.addTrackPointAnnotation(item.location, '起点', '#37800f')

    // 如果终点也已选择，计算距离和碳排放
    if (this.endPoint) {
      this.calculateDistance()
      this.calculateCarbonEmission()
    }
  }

  // 处理终点搜索结果选择
  private handleEndSearchResultSelected(item: SiteItem): void {
    if (!item.location) {
      return
    }

    // 设置终点位置
    this.endPoint = item.location
    this.endPointText = item.name || `${item.location.latitude.toFixed(6)}, ${item.location.longitude.toFixed(6)}`

    // 移动到该位置
    this.moveToLocation(item.location)

    // 隐藏搜索结果
    this.showEndSearchResults = false

    // 添加终点标注
    this.addTrackPointAnnotation(item.location, '终点', '#d95011')

    // 如果起点也已选择，计算距离和碳排放
    if (this.startPoint) {
      this.calculateDistance()
      this.calculateCarbonEmission()
    }
  }

  // 移动地图到指定位置
  private async moveToLocation(location: Location, zoom: number = 16): Promise<void> {
    if (!this.mapController) {
      return
    }

    try {
      let cameraPosition: mapCommon.CameraPosition = {
        target: { latitude: location.latitude, longitude: location.longitude },
        zoom: zoom,
        tilt: 0,
        bearing: 0
      }
      let cameraUpdate = map.newCameraPosition(cameraPosition)
      this.mapController.animateCamera(cameraUpdate, 1000)
    } catch (error) {
      console.error(`移动地图失败：${error.code}, ${error.message}`)
    }
  }

  private async saveTrackRecord(): Promise<void> {
    if (!this.startPoint || !this.endPoint || this.trackInfo.distance === 0) {
      return
    }


    try {
      const trackRecord: TrackRecord = {
        id: Date.now(),
        startPoint: this.startPoint,
        endPoint: this.endPoint,
        trackInfo: this.trackInfo,
        createdAt: new Date().toISOString()
      };

      console.info(`轨迹记录已保存：${JSON.stringify(trackRecord)}`);


    } catch (error) {
      console.error(`保存轨迹记录失败：${error.code}, ${error.message}`);
    }
  }

  private async fitTrackToView(): Promise<void> {
    if (!this.mapController || !this.startPoint || !this.endPoint) {
      return;
    }

    try {
      const bounds: mapCommon.LatLngBounds = {
        northeast: {
          latitude: Math.max(this.startPoint.latitude, this.endPoint.latitude) + 0.01,
          longitude: Math.max(this.startPoint.longitude, this.endPoint.longitude) + 0.01
        },
        southwest: {
          latitude: Math.min(this.startPoint.latitude, this.endPoint.latitude) - 0.01,
          longitude: Math.min(this.startPoint.longitude, this.endPoint.longitude) - 0.01
        }
      };

      const cameraUpdate = map.newLatLngBounds(bounds, 50); // 50像素边距
      /*await */
      this.mapController.animateCamera(cameraUpdate, 1000);

    } catch (error) {
      console.error(`调整地图视野失败：${error.code}, ${error.message}`);
    }
  }

  // 弧线绘制功能
  private async drawTrackArc(): Promise<void> {
    if (!this.mapController || !this.startPoint || !this.endPoint) {
      return;
    }

    try {
      // 先清除现有的弧线
      // await this.clearTrackArc();

      // 创建弧线参数（假设华为地图API支持addArc）
      const arcOptions: mapCommon.MapArcParams = {
        startPoint: {
          latitude: this.startPoint.latitude,
          longitude: this.startPoint.longitude
        },
        centerPoint: {
          latitude: (this.startPoint.latitude + this.endPoint.latitude) / 2.3,
          longitude: (this.startPoint.longitude + this.endPoint.longitude) / 2.2,
        },
        endPoint: {
          latitude: this.endPoint.latitude,
          longitude: this.endPoint.longitude
        },
        color: this.hexToArgb('#37800f'),
        width: 5,
        zIndex: 5,
      };

      // 添加弧线
      try {
        this.mapArc = this.mapController.addArc(arcOptions)
      } catch (e) {
        console.error(`Failed to create the mapArc, code is：${e.code}, message is ${e.message}`)
      }

      // // 调整地图视野以显示整个轨迹
      // await this.fitTrackToView()

    } catch (error) {
      console.error(`绘制轨迹失败：${error.code}, ${error.message}`);
      // // 备选方案：使用折线代替弧线
      // await this.drawTrackPolyline();
    }
  }

  private getTransportLabel(transportType: TransportType): string {
    const option = this.transportOptions.find(opt => opt.value === transportType);
    return option?.label || transportType;
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

  private hexToArgb(hexColor: string): number {
    // 将 #RRGGBB 转换为 ARGB 整数
    const hex = hexColor.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);
    return (0xFF << 24) | (r << 16) | (g << 8) | b;
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

  build() {
    Column({ space: 15 }) {
      // 标题和关闭按钮
      Row() {
        Text('碳轨迹计算')
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
            this.isShow2 = false
            this.clearTrack()
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      // 起点/终点输入区域
      Column({ space: 10 }) {
        Text('起点/终点选择')
          .fontSize(16)
          .fontColor('#37800f')
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)

        // 起点输入
        Column({ space: 5 }) {
          Row() {
            TextInput({ placeholder: '选择起点或输入地址', text: $$this.startPointText })
              .layoutWeight(1)
              .fontColor('#000')
              .placeholderColor('#999')
              .backgroundColor(Color.Transparent)
              .onChange((value: string) => {
                this.startPointText = value
                this.performStartSearch(value)
                this.showPointSelectionHint = true
              })

            Image($r('app.media.map_search'))
              .width(25)
              .margin({ left: 10 })
              .fillColor(this.startPointText.trim().length > 0 ? '#37800f' : '#ccc')
              .onClick(() => {
                if (this.startPointText.trim().length > 0) {
                  this.performStartSearch(this.startPointText)
                }
              })
          }
          .border({ width: 1, color: this.startPoint ? '#37800f' : '#ccc', radius: 12 })
          .padding({
            left: 10,
            right: 10,
            top: 10,
            bottom: 10
          })
          .backgroundColor('#F9FFFD')

          // 起点搜索结果
          if (this.showStartSearchResults) {
            Column({ space: 5 }) {
              if (this.startSearchLoading) {
                Row() {
                  LoadingProgress().width(20).height(20).color('#37800f')
                  Text('搜索中...').fontSize(14).fontColor('#666666').margin({ left: 10 })
                }
                .width('100%')
                .padding(12)
                .justifyContent(FlexAlign.Center)
              } else if (this.startSearchResults.length > 0) {
                Column({ space: 8 }) {
                  Row() {
                    Text(`找到 ${this.startSearchResults.length} 个结果`)
                      .fontSize(14)
                      .fontColor('#37800f')
                      .fontWeight(FontWeight.Medium)
                      .layoutWeight(1)
                      .textAlign(TextAlign.Start)

                    Image($r('app.media.arrow_up'))
                      .rotate({ angle: 180 })
                      .width(20)
                      .fillColor('#37800f')
                      .opacity(0.7)
                      .onClick(() => {
                        this.showStartSearchResults = false
                      })
                  }
                  .width('100%')
                  .padding({ left: 5, bottom: 5 })

                  Scroll() {
                    Column({ space: 5 }) {
                      ForEach(this.startSearchResults, (item: SiteItem, index: number) => {
                        Column() {
                          Row() {
                            Column({ space: 2 }) {
                              Text(item.name ?? '未知地点')
                                .fontSize(15)
                                .fontColor('#000000')
                                .fontWeight(FontWeight.Medium)
                                .maxLines(1)
                                .textOverflow({ overflow: TextOverflow.Ellipsis })

                              if (item.formatAddress) {
                                Text(item.formatAddress)
                                  .fontSize(12)
                                  .fontColor('#666666')
                                  .maxLines(1)
                                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                              }

                              if (item.location) {
                                Text(`经纬度: ${item.location.latitude.toFixed(6)}, ${item.location.longitude.toFixed(6)}`)
                                  .fontSize(11)
                                  .fontColor('#37800f')
                                  .maxLines(1)
                                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                              }
                            }
                            .width('90%')

                            Image($r('app.media.arrow_up'))
                              .rotate({ angle: 90 })
                              .width(18)
                              .fillColor('#37800f')
                              .opacity(0.7)
                          }
                          .width('100%')
                          .padding(10)
                          .backgroundColor('#FFFFFF')
                          .borderRadius(10)
                          .shadow({
                            radius: 2,
                            color: '#00000010',
                            offsetX: 0,
                            offsetY: 1
                          })
                          .onClick(() => {
                            this.handleStartSearchResultSelected(item)
                          })
                          .animation({ duration: 200, curve: Curve.EaseInOut })

                          if (index < this.startSearchResults.length - 1) {
                            Divider().strokeWidth(1).color('#E0E0E0')
                          }
                        }
                      })
                    }
                    .width('100%')
                  }
                  .width('100%')
                  .height(180)
                }
                .width('100%')
                .padding(5)
                .backgroundColor('#FFFFFF')
                .borderRadius(12)
                .shadow({
                  radius: 8,
                  color: '#00000020',
                  offsetX: 0,
                  offsetY: 3
                })
              } else if (this.startPointText.trim().length > 0) {
                Row() {
                  Text('未找到相关地点').fontSize(14).fontColor('#999999')
                }
                .width('100%')
                .padding(15)
                .justifyContent(FlexAlign.Center)
                .backgroundColor('#FFFFFF')
                .borderRadius(12)
              }
            }
            .width('100%')
            .border({ width: 1, color: '#ccc', radius: 12 })
          }
        }
        .width('100%')

        // 终点输入
        Column({ space: 5 }) {
          Row() {
            TextInput({ placeholder: '选择终点或输入地址', text: $$this.endPointText })
              .layoutWeight(1)
              .fontColor('#000')
              .placeholderColor('#999')
              .backgroundColor(Color.Transparent)
              .onChange((value: string) => {
                this.endPointText = value
                this.performEndSearch(value)
                this.showPointSelectionHint = true
              })

            Image($r('app.media.map_search'))
              .width(25)
              .margin({ left: 10 })
              .fillColor(this.endPointText.trim().length > 0 ? '#37800f' : '#ccc')
              .onClick(() => {
                if (this.endPointText.trim().length > 0) {
                  this.performEndSearch(this.endPointText)
                }
              })
          }
          .border({ width: 1, color: this.endPoint ? '#37800f' : '#ccc', radius: 12 })
          .padding({
            left: 10,
            right: 10,
            top: 10,
            bottom: 10
          })
          .backgroundColor('#F9FFFD')

          // 终点搜索结果
          if (this.showEndSearchResults) {
            Column({ space: 5 }) {
              if (this.endSearchLoading) {
                Row() {
                  LoadingProgress().width(20).height(20).color('#37800f')
                  Text('搜索中...').fontSize(14).fontColor('#666666').margin({ left: 10 })
                }
                .width('100%')
                .padding(12)
                .justifyContent(FlexAlign.Center)
              } else if (this.endSearchResults.length > 0) {
                Column({ space: 8 }) {
                  Row() {
                    Text(`找到 ${this.endSearchResults.length} 个结果`)
                      .fontSize(14)
                      .fontColor('#37800f')
                      .fontWeight(FontWeight.Medium)
                      .layoutWeight(1)
                      .textAlign(TextAlign.Start)

                    Image($r('app.media.arrow_up'))
                      .rotate({ angle: 180 })
                      .width(20)
                      .fillColor('#37800f')
                      .opacity(0.7)
                      .onClick(() => {
                        this.showEndSearchResults = false
                      })
                  }
                  .width('100%')
                  .padding({ left: 5, bottom: 5 })

                  Scroll() {
                    Column({ space: 5 }) {
                      ForEach(this.endSearchResults, (item: SiteItem, index: number) => {
                        Column() {
                          Row() {
                            Column({ space: 2 }) {
                              Text(item.name ?? '未知地点')
                                .fontSize(15)
                                .fontColor('#000000')
                                .fontWeight(FontWeight.Medium)
                                .maxLines(1)
                                .textOverflow({ overflow: TextOverflow.Ellipsis })

                              if (item.formatAddress) {
                                Text(item.formatAddress)
                                  .fontSize(12)
                                  .fontColor('#666666')
                                  .maxLines(1)
                                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                              }

                              if (item.location) {
                                Text(`经纬度: ${item.location.latitude.toFixed(6)}, ${item.location.longitude.toFixed(6)}`)
                                  .fontSize(11)
                                  .fontColor('#37800f')
                                  .maxLines(1)
                                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                              }
                            }
                            .width('90%')

                            Image($r('app.media.arrow_up'))
                              .rotate({ angle: 90 })
                              .width(18)
                              .fillColor('#37800f')
                              .opacity(0.7)
                          }
                          .width('100%')
                          .padding(10)
                          .backgroundColor('#FFFFFF')
                          .borderRadius(10)
                          .shadow({
                            radius: 2,
                            color: '#00000010',
                            offsetX: 0,
                            offsetY: 1
                          })
                          .onClick(() => {
                            this.handleEndSearchResultSelected(item)
                          })
                          .animation({ duration: 200, curve: Curve.EaseInOut })

                          if (index < this.endSearchResults.length - 1) {
                            Divider().strokeWidth(1).color('#E0E0E0')
                          }
                        }
                      })
                    }
                    .width('100%')
                  }
                  .width('100%')
                  .height(180)
                }
                .width('100%')
                .padding(5)
                .backgroundColor('#FFFFFF')
                .borderRadius(12)
                .shadow({
                  radius: 8,
                  color: '#00000020',
                  offsetX: 0,
                  offsetY: 3
                })
              } else if (this.endPointText.trim().length > 0) {
                Row() {
                  Text('未找到相关地点').fontSize(14).fontColor('#999999')
                }
                .width('100%')
                .padding(15)
                .justifyContent(FlexAlign.Center)
                .backgroundColor('#FFFFFF')
                .borderRadius(12)
              }
            }
            .width('100%')
            .border({ width: 1, color: '#ccc', radius: 12 })
          }
        }
        .width('100%')
      }
      .width('100%')

      // 交通方式选择
      Column({ space: 10 }) {
        Text('交通方式')
          .fontSize(16)
          .fontColor('#37800f')
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)

        Row({ space: 10 }) {
          ForEach(this.transportOptions, (option: TransportOption) => {
            Column({ space: 5 }) {
              Image(option.icon)
                .width(30)
                .height(30)
                .fillColor(this.selectedTransport === option.value ? '#37800f' : '#666')

              Text(option.label)
                .fontSize(12)
                .fontColor(this.selectedTransport === option.value ? '#37800f' : '#666')
            }
            .padding(10)
            .border({
              width: 2,
              color: this.selectedTransport === option.value ? '#37800f' : '#e0e0e0',
              radius: 10
            })
            .backgroundColor(this.selectedTransport === option.value ? '#F3FEF3' : '#FFFFFF')
            .onClick(() => {
              this.selectedTransport = option.value
              if (this.startPoint && this.endPoint) {
                this.calculateDistance()
                this.calculateCarbonEmission()
              }
            })
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')

      // 轨迹信息展示
      if (this.trackInfo.distance > 0) {
        Column({ space: 10 }) {
          Text('轨迹信息')
            .fontSize(16)
            .fontColor('#37800f')
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)

          Row() {
            Column({ space: 5 }) {
              Text('距离')
                .fontSize(14)
                .fontColor('#666')
              Text(`${this.trackInfo.distance.toFixed(2)} km`)
                .fontSize(16)
                .fontColor('#37800f')
                .fontWeight(FontWeight.Medium)
            }
            .width('50%')

            Column({ space: 5 }) {
              Text('碳排放')
                .fontSize(14)
                .fontColor('#666')
              Text(`${this.trackInfo.carbonEmission.toFixed(2)} kg`)
                .fontSize(16)
                .fontColor('#d95011')
                .fontWeight(FontWeight.Medium)
            }
            .width('50%')
          }
          .width('100%')

          Row() {
            Column({ space: 5 }) {
              Text('预计时间')
                .fontSize(14)
                .fontColor('#666')
              Text(`${this.trackInfo.estimatedTime} min`)
                .fontSize(16)
                .fontColor('#37800f')
            }
            .width('50%')

            Column({ space: 5 }) {
              Text('交通方式')
                .fontSize(14)
                .fontColor('#666')
              Text(this.getTransportLabel(this.selectedTransport))
                .fontSize(16)
                .fontColor('#37800f')
            }
            .width('50%')
          }
          .width('100%')
        }
        .width('100%')
        .padding(15)
        .backgroundColor('#F9FFFD')
        .border({ width: 1, color: '#81B29A', radius: 15 })
      }

      // 控制按钮区域
      Row({ space: 15 }) {
        Button('绘制轨迹')
          .width('45%')
          .height(45)
          .backgroundColor(this.startPoint && this.endPoint ? '#37800f' : '#ccc')
          .fontColor('#fff')
          .fontSize(16)
          .enabled(this.startPoint !== null && this.endPoint !== null)
          .onClick(() => {
            this.drawTrackArc()
          })

        Button('清除轨迹')
          .width('45%')
          .height(45)
          .backgroundColor('#d95011')
          .fontColor('#fff')
          .fontSize(16)
          .onClick(() => {
            // this.clearTrack()
          })
      }
      .width('100%')
      .margin({ top: 20 })

      // 保存按钮
      if (this.trackInfo.distance > 0) {
        Button('保存轨迹记录')
          .width('100%')
          .height(45)
          .backgroundColor('#81B29A')
          .fontColor('#fff')
          .fontSize(16)
          .onClick(() => {
            this.saveTrackRecord()
          })
      }
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 25 })
  }
}