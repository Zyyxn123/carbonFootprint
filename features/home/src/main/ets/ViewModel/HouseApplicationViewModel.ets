import { ApplianceTotalDataType } from "@ohos/utils"
import { ApplianceDataModel } from "../Model/HouseApplicationModel"
import { cardsDataTypeModel, popBoxDataTypeModel, transportsTypeModel } from "../Model/ToDoItemsModel"

@ObservedV2
class houseApplicationViewModel {
  @Trace cardsData: cardsDataTypeModel[] = [
    {
      text: '累计碳排',
      num: 0.0,
      unit: 'kg'
    },
    {
      text: '本月目标完成度 68%',
      num: 0.0,
      unit: 'kg'
    },
    {
      text: '低碳用电',
      num: 0,
      unit: '天',
      img: $r('app.media.icon_bulb')
    }
  ]
  @Trace popBoxData: popBoxDataTypeModel[] = [
    {
      text: '本月用电次数',
      num: 0,
      unit: ''
    },
    {
      text: '本月总耗时',
      num: 0,
      unit: 'h'
    },
    {
      text: '获得节能积分',
      num: 0,
      unit: ''
    },
    {
      text: '节能勋章',
      num: 1,
      unit: ''
    }
  ]
  @Trace applicationsLists: transportsTypeModel[] = [
    {
      ts: '冰箱',
      tsc: '#2196F3',
      bgc: '#0F4C81',
      img: $r('app.media.appliances_bingxiang'),
      carEmissionPer: 120.7,
      pointsPerOrder: 7
    },
    {
      ts: '空调',
      tsc: '#03A9F4',
      bgc: '#0B699E',
      img: $r('app.media.appliances_kongtiao'),
      carEmissionPer: 800.2,
      pointsPerOrder: 3
    },
    {
      ts: '电饭煲',
      tsc: '#FF9800',
      bgc: '#6B4423',
      img: $r('app.media.appliances_dianfanbao'),
      carEmissionPer: 350.6,
      pointsPerOrder: 5
    },
    {
      ts: '洗衣机',
      tsc: '#009688',
      bgc: '#004D40',
      img: $r('app.media.appliances_xiyiji'),
      carEmissionPer: 280.4,
      pointsPerOrder: 6
    },
    {
      ts: '电视机',
      tsc: '#9C27B0',
      bgc: '#4A148C',
      img: $r('app.media.appliances_dianshiji'),
      carEmissionPer: 60.3,
      pointsPerOrder: 8
    },
    {
      ts: '电脑',
      tsc: '#607D8B',
      bgc: '#34495E',
      img: $r('app.media.appliances_diannao'),
      carEmissionPer: 75.5,
      pointsPerOrder: 8
    },
    {
      ts: '电热水器',
      tsc: '#F44336',
      bgc: '#B71C1C',
      img: $r('app.media.appliances_dianreshuiqi'),
      carEmissionPer: 1500.8,
      pointsPerOrder: 2
    },
    {
      ts: '电风扇',
      tsc: '#4CAF50',
      bgc: '#2D5F2E',
      img: $r('app.media.appliances_dianfengshan'),
      carEmissionPer: 15.4,
      pointsPerOrder: 9
    },
    {
      ts: '微波炉',
      tsc: '#FF5722',
      bgc: '#5D4037',
      img: $r('app.media.appliances_weibolu'),
      carEmissionPer: 420.6,
      pointsPerOrder: 4
    },
    {
      ts: '电磁炉',
      tsc: '#795548',
      bgc: '#3E2723',
      img: $r('app.media.appliances_diancilu'),
      carEmissionPer: 650.5,
      pointsPerOrder: 4
    },
    {
      ts: '吸尘器',
      tsc: '#9E9E9E',
      bgc: '#424242',
      img: $r('app.media.appliances_xichenqi'),
      carEmissionPer: 200.2,
      pointsPerOrder: 6
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
  @Trace title: string = '选择你使用的电器'
  @Trace subHeading: string = '出行足迹'
  @Trace id: number = -1
  @Trace total_emission: number = 0.0
  @Trace total_day: number = 0
  @Trace monthly_emission: number = 0.0
  @Trace monthly_order: number = 0
  @Trace monthly_degree: number = 0
  @Trace point: number = 0
  @Trace medal: number = 0
  @Trace time_token: string = ''
  @Trace acc: string = AppStorage.get('currLoginAcc') as string

  public async getTotalData(acc: string) {
    const dataItem: ApplianceTotalDataType = await ApplianceDataModel.getTotalData(acc)
    this.id = dataItem.id
    this.total_emission = dataItem.total_emission
    this.total_day = dataItem.total_day
    this.monthly_emission = dataItem.monthly_emission
    this.monthly_order = dataItem.monthly_order
    this.monthly_degree = dataItem.monthly_degree
    this.point = dataItem.point
    this.medal = dataItem.medal
    this.time_token = dataItem.time_token

    this.cardsData[0] = { text: '累计碳排', num: this.total_emission, unit: 'kg' }
    this.cardsData[1].num = this.monthly_emission
    this.cardsData[2].num = this.total_day
    this.popBoxData[0] = { text: '本月用电次数', num: this.monthly_order, unit: '' }
    this.popBoxData[1].num = this.monthly_degree
    this.popBoxData[2].num = this.point
    this.popBoxData[3].num = this.medal
  }

  public async updateTotalData(acc: string) {
    let data: ApplianceTotalDataType = {
      id: this.id,
      account: acc,
      total_emission: this.total_emission,
      total_day: this.total_day,
      monthly_emission: this.monthly_emission,
      monthly_order: this.monthly_order,
      monthly_degree: this.monthly_degree,
      point: this.point,
      medal: this.medal,
      time_token: this.time_token
    }
    await ApplianceDataModel.updateTotalData(data)
  }

  public insertItemData(appliance: string, totalCarEmi: number,
    use_time: number, elect_power: number) {
    let date = new Date().toLocaleDateString()

    ApplianceDataModel.insertItemData(this.acc, appliance, use_time,
      elect_power, date, totalCarEmi)
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

  public setMonthlyDegree(dis: number) {
    this.monthly_degree += dis
    this.popBoxData[1].num += dis
  }

  public setPoint(point: number) {
    this.point += point
    this.popBoxData[2].num += point
  }

}

const HouseAPPVM: houseApplicationViewModel = new houseApplicationViewModel()

export default HouseAPPVM