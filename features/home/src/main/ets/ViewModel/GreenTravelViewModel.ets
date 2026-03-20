import { TransTotalDataType } from '@ohos/utils'
import { TransDataModel } from '../Model/GreenTravelModel'
import { cardsDataTypeModel, popBoxDataTypeModel, transportsTypeModel } from '../Model/ToDoItemsModel'

@ObservedV2
class GreenTravelViewModel {
  @Trace cardsData: cardsDataTypeModel[] = [
    {
      text: '累计碳排',
      num: 0.0,
      unit: 'kg'
    },
    {
      text: '本月碳排量 76%',
      num: 0.0,
      unit: 'kg'
    },
    {
      text: '累计出行',
      num: 0,
      unit: '天',
      img: $r('app.media.icon_leave')
    }
  ]
  @Trace popBoxData: popBoxDataTypeModel[] = [
    {
      text: '本月出行次数',
      num: 0,
      unit: ''
    },
    {
      text: '本月出行里程',
      num: 0,
      unit: 'km'
    },
    {
      text: '获得积分',
      num: 0,
      unit: ''
    },
    {
      text: '环保勋章',
      num: 1,
      unit: ''
    }
  ]
  @Trace transportLists: transportsTypeModel[] = [
    {
      ts: '骑行',
      tsc: '#4CAF50',
      bgc: '#2D5F2E',
      img: $r('app.media.transports_zixingche'),
      carEmissionPer: 0.0, // 原carEmissionPerKilo，每公里碳排放
      pointsPerOrder: 10
    },
    {
      ts: '步行',
      tsc: '#FFC107',
      bgc: '#6B5A1E',
      img: $r('app.media.transports_buxing'),
      carEmissionPer: 0.0,
      pointsPerOrder: 10
    },
    {
      ts: '电动车',
      tsc: '#E91E63',
      bgc: '#4A235A',
      img: $r('app.media.transports_diandongche'),
      carEmissionPer: 15.2,
      pointsPerOrder: 9
    },
    {
      ts: '公交车',
      tsc: '#2196F3',
      bgc: '#0F4C81',
      img: $r('app.media.transports_gongjiaoche'),
      carEmissionPer: 82.3,
      pointsPerOrder: 7
    },
    {
      ts: '地铁',
      tsc: '#4CAF50',
      bgc: '#2D5F2E',
      img: $r('app.media.transports_ditie'),
      carEmissionPer: 65.4,
      pointsPerOrder: 8
    },
    {
      ts: '高铁',
      tsc: '#FF9800',
      bgc: '#6B4423',
      img: $r('app.media.transports_gaotie'),
      carEmissionPer: 41.5,
      pointsPerOrder: 9
    },
    {
      ts: '火车',
      tsc: '#795548',
      bgc: '#3E2723',
      img: $r('app.media.transports_huoche'),
      carEmissionPer: 90.6,
      pointsPerOrder: 6
    },
    {
      ts: '飞机',
      tsc: '#3F51B5',
      bgc: '#1A237E',
      img: $r('app.media.transports_feiji'),
      carEmissionPer: 250.7,
      pointsPerOrder: 2
    },
    {
      ts: '邮轮',
      tsc: '#009688',
      bgc: '#004D40',
      img: $r('app.media.transports_youlun'),
      carEmissionPer: 180.8,
      pointsPerOrder: 3
    },
    {
      ts: '私家车',
      tsc: '#FF5722',
      bgc: '#5D4037',
      img: $r('app.media.transports_sijiache'),
      carEmissionPer: 171.9,
      pointsPerOrder: 4
    },
    {
      ts: '长途',
      tsc: '#8BC34A',
      bgc: '#33691E',
      img: $r('app.media.transports_gongjiaoche'),
      carEmissionPer: 105.1,
      pointsPerOrder: 5
    },
    {
      ts: '更多',
      tsc: '#9E9E9E',
      bgc: '#424242',
      img: $r('app.media.func_add'),
      carEmissionPer: 0,
      pointsPerOrder: 1
    }
  ]
  @Trace title: string = '选择你的出行方式'
  @Trace subHeading: string = '出行足迹'
  @Trace id: number = -1
  @Trace total_emission: number = 0.0
  @Trace total_day: number = 0
  @Trace monthly_emission: number = 0.0
  @Trace monthly_order: number = 0
  @Trace monthly_distance: number = 0
  @Trace point: number = 0
  @Trace medal: number = 0
  @Trace time_token: string = ''
  @Trace acc: string = AppStorage.get('currLoginAcc') as string

  public async getTotalData(acc: string) {
    const dataItem: TransTotalDataType = await TransDataModel.getTotalData(acc)
    console.log('setCarEmiDay: ' + this.time_token)
    this.id = dataItem.id
    this.total_emission = dataItem.total_emission
    this.total_day = dataItem.total_day
    this.monthly_emission = dataItem.monthly_emission
    this.monthly_order = dataItem.monthly_order
    this.monthly_distance = dataItem.monthly_distance
    this.point = dataItem.point
    this.medal = dataItem.medal
    this.time_token = dataItem.time_token

    this.cardsData[0] = { text: '累计碳排', num: this.total_emission, unit: 'kg' }
    this.cardsData[1].num = this.monthly_emission
    this.cardsData[2].num = this.total_day
    this.popBoxData[0] = { text: '本月出行次数', num: this.monthly_order, unit: '' }
    this.popBoxData[1].num = this.monthly_distance
    this.popBoxData[2].num = this.point
    this.popBoxData[3].num = this.medal
  }

  public async updateTotalData(acc: string) {
    let data: TransTotalDataType = {
      id: this.id,
      account: acc,
      total_emission: this.total_emission,
      total_day: this.total_day,
      monthly_emission: this.monthly_emission,
      monthly_order: this.monthly_order,
      monthly_distance: this.monthly_distance,
      point: this.point,
      medal: this.medal,
      time_token: this.time_token
    }
    await TransDataModel.updateTotalData(data)
  }

  public insertItemData(transport: string, totalCarEmi: number, mileage: number,
    tripTime: number) {
    let date = new Date().toLocaleDateString()

    TransDataModel.insertItemData(this.acc, transport, mileage,
      tripTime, date, totalCarEmi)
  }

  public setCarEmiData(emi: number) {
    this.cardsData[0] = {
      text: '累计碳排',
      num: this.total_emission + emi,
      unit: 'kg'
    }
    this.cardsData[1] = {
      text: '本月碳排量 76%',
      num: this.total_emission + emi,
      unit: 'kg'
    }
    this.total_emission += emi
    this.monthly_emission += emi
  }

  public setCarEmiDay() {
    let date = new Date()
    console.log('setCarEmiDay: ' + `${date.toLocaleDateString()}//${this.time_token}`)
    if (date.toLocaleDateString() !== this.time_token) {
      this.total_day += 1
      this.monthly_order += 1
      this.cardsData[2].num += 1
      this.popBoxData[0].num += 1

      this.time_token = date.toLocaleDateString()
    } else {
      this.monthly_order += 1
      this.popBoxData[0].num += 1
    }
  }

  public setOutDistance(dis: number) {
    this.monthly_distance += dis
    this.popBoxData[1].num += dis
  }

  public setPoint(point: number) {
    this.point += point
    this.popBoxData[2].num += point
  }
}

const GreenTVM: GreenTravelViewModel = new GreenTravelViewModel()

export default GreenTVM