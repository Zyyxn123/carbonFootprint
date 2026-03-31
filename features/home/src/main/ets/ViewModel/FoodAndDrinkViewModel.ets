import { FoodItemDataType, FoodTotalDataType } from '@ohos/utils'
import { FoodDataModel } from '../Model/FoodAndDrinkModel'
import { cardsDataTypeModel, popBoxDataTypeModel, transportsTypeModel } from '../Model/ToDoItemsModel'

@ObservedV2
class FoodAndDrinkViewModel {
  @Trace cardsData: cardsDataTypeModel[] = [
    {
      text: '累计碳排',
      num: 0,
      unit: 'kg'
    },
    {
      text: '本月目标完成度 82%',
      num: 0,
      unit: 'kg'
    },
    {
      text: '低碳饮食',
      num: 0,
      unit: '天',
      img: $r('app.media.icon_vegetable')
    }
  ]
  @Trace popBoxData: popBoxDataTypeModel[] = [
    {
      text: '本月饮食次数',
      num: 0,
      unit: ''
    },
    {
      text: '食材份量',
      num: 0,
      unit: 'g'
    },
    {
      text: '低碳饮食积分',
      num: 0,
      unit: ''
    },
    {
      text: '低碳勋章',
      num: 0,
      unit: ''
    }
  ]
  // g/g
  @Trace foodAndDrinkLists: transportsTypeModel[] = [
    {
      ts: '米饭',
      tsc: '#8D6E63',
      bgcCard: '#EFEBE9',
      bgc: '#5D4037',
      img: $r('app.media.food_mifan'),
      carEmissionPer: 0.85,
      pointsPerOrder: 7
    },
    {
      ts: '青菜',
      tsc: '#4CAF50',
      bgcCard: '#E8F5E9',
      bgc: '#2D5F2E',
      img: $r('app.media.food_qingcai'),
      carEmissionPer: 0.18,
      pointsPerOrder: 9
    },
    {
      ts: '猪肉',
      tsc: '#E57373',
      bgcCard: '#FFEBEE',
      bgc: '#B71C1C',
      img: $r('app.media.food_zhurou'),
      carEmissionPer: 12.8,
      pointsPerOrder: 2
    },
    {
      ts: '鸡蛋',
      tsc: '#FFC107',
      bgcCard: '#FFF8E1',
      bgc: '#6B5A1E',
      img: $r('app.media.food_jidan'),
      carEmissionPer: 4.8,
      pointsPerOrder: 5
    },
    {
      ts: '牛奶',
      tsc: '#F5F5F5',
      bgcCard: '#FAFAFA',
      bgc: '#9E9E9E',
      img: $r('app.media.food_niunai'),
      carEmissionPer: 3.2,
      pointsPerOrder: 6
    },
    {
      ts: '咖啡',
      tsc: '#795548',
      bgcCard: '#EFEBE9',
      bgc: '#3E2723',
      img: $r('app.media.food_kafei'),
      carEmissionPer: 11.2,
      pointsPerOrder: 6
    },
    {
      ts: '苹果',
      tsc: '#F44336',
      bgcCard: '#FFEBEE',
      bgc: '#C62828',
      img: $r('app.media.food_pingguo'),
      carEmissionPer: 0.42,
      pointsPerOrder: 8
    },
    {
      ts: '豆制品',
      tsc: '#FFEB3B',
      bgcCard: '#FFFDE7',
      bgc: '#F57F17',
      img: $r('app.media.food_douzhipin'),
      carEmissionPer: 0.95,
      pointsPerOrder: 8
    },
    {
      ts: '鸡肉',
      tsc: '#FFCCBC',
      bgcCard: '#FBE9E7',
      bgc: '#8D6E63',
      img: $r('app.media.food_jirou'),
      carEmissionPer: 6.9,
      pointsPerOrder: 4
    },
    {
      ts: '饮用水',
      tsc: '#2196F3',
      bgcCard: '#E3F2FD',
      bgc: '#0F4C81',
      img: $r('app.media.food_yinyongshui'),
      carEmissionPer: 0.008,
      pointsPerOrder: 10
    },
    {
      ts: '面包',
      tsc: '#FF9800',
      bgcCard: '#FFF3E0',
      bgc: '#E65100',
      img: $r('app.media.food_mianbao'),
      carEmissionPer: 1.15,
      pointsPerOrder: 7
    },
    {
      ts: '更多',
      tsc: '#9E9E9E',
      bgcCard: '#F5F5F5',
      bgc: '#424242',
      img: $r('app.media.func_add'),
      carEmissionPer: 0.0,
      pointsPerOrder: 1
    }
  ]
  @Trace foodItemList: FoodItemDataType[] = []
  @Trace title: string = '请选择你的饮食'
  @Trace subHeading: string = '饮食足迹'
  @Trace id: number = -1
  @Trace total_emission: number = 0.0
  @Trace total_day: number = 0
  @Trace monthly_emission: number = 0.0
  @Trace monthly_order: number = 0
  @Trace monthly_portion: number = 0
  @Trace point: number = 0
  @Trace medal: number = 0
  @Trace time_token: string = ''
  @Trace acc: string = AppStorage.get('currLoginAcc') as string

  public async getTotalData(acc: string) {
    const dataItem: FoodTotalDataType = await FoodDataModel.getTotalData(acc)
    console.log('setCarEmiDay: ' + this.time_token)
    this.id = dataItem.id
    this.total_emission = dataItem.total_emission
    this.total_day = dataItem.total_day
    this.monthly_emission = dataItem.monthly_emission
    this.monthly_order = dataItem.monthly_order
    this.monthly_portion = dataItem.monthly_portion
    this.point = dataItem.point
    this.medal = dataItem.medal
    this.time_token = dataItem.time_token

    this.cardsData[0] = { text: '累计碳排', num: this.total_emission, unit: 'kg' }
    this.cardsData[1].num = this.monthly_emission
    this.cardsData[2].num = this.total_day
    this.popBoxData[0] = { text: '本月饮食次数', num: this.monthly_order, unit: '' }
    this.popBoxData[1].num = this.monthly_portion
    this.popBoxData[2].num = this.point
    this.popBoxData[3].num = this.medal

    const dataItemList: FoodItemDataType[] = await FoodDataModel.getFoodItemData(acc)
    this.foodItemList = dataItemList.reverse()
  }

  public async updateTotalData(acc: string) {
    let data: FoodTotalDataType = {
      id: this.id,
      account: acc,
      total_emission: this.total_emission,
      total_day: this.total_day,
      monthly_emission: this.monthly_emission,
      monthly_order: this.monthly_order,
      monthly_portion: this.monthly_portion,
      point: this.point,
      medal: this.medal,
      time_token: this.time_token
    }
    await FoodDataModel.updateTotalData(data)
  }

  public updateItemData(food: string, totalCarEmi: number,
    eat_portion: number, eat_time: number) {
    let date = new Date().toLocaleDateString()

    FoodDataModel.updateItemData(this.acc, food, eat_portion,
      eat_time, date, totalCarEmi)
  }

  public setItemListData(food: string, totalCarEmi: number,
    eat_portion: number, eat_time: number) {
    let date = new Date().toLocaleDateString()

    const dataItem: FoodItemDataType = {
      id: this.id,
      account: this.acc,
      food: food,
      eat_portion: eat_portion,
      eat_time: eat_time,
      time_token: date,
      carbon_emission: totalCarEmi
    }

    this.foodItemList.unshift(dataItem)
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

  public setMonthlyPortion(dis: number) {
    this.monthly_portion += dis
    this.popBoxData[1].num += dis
  }

  public setPoint(point: number) {
    this.point += point
    this.popBoxData[2].num += point
  }
}

const FoodDVM: FoodAndDrinkViewModel = new FoodAndDrinkViewModel()

export default FoodDVM