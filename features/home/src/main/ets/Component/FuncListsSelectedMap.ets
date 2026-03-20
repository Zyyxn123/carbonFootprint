import { transportsTypeModel } from "../Model/ToDoItemsModel"
import GreenTVM from "../ViewModel/GreenTravelViewModel"

@Component
export struct funcListsSelectedMap {
  @State isShow: boolean = false
  @State textFir: string = ''
  @State textSec: string = ''
  @State predictReduce: number = 0
  @State currIndex: number = 0
  @Prop index_page: number
  @Prop funcList: transportsTypeModel[]
  @Prop title: string
  private sheetHeight: number = 800

  @Builder
  bindSheet_first(index: number, item: transportsTypeModel) {
    Column({ space: 25 }) {
      Row({ space: 10 }) {
        Image($r('app.media.BS_fir_transport'))
          .width(30)
          .fillColor('#37800f')
        Text('交通工具')
          .fontColor('#000')
          .fontSize(18)
        Text(this.funcList[index].ts)
          .fontColor('#000')
          .fontSize(16)
          .width('65%')
          .textAlign(TextAlign.End)
          .padding({ right: 15 })
      }

      Row({ space: 10 }) {
        Image($r('app.media.BS_fir_footprint'))
          .width(30)
          .fillColor('#37800f')
        Text('出行里程')
          .fontColor('#000')
          .fontSize(18)
        TextInput({ placeholder: '请输入里程(km)', text: $$this.textFir })
          .placeholderColor('#ccc')
          .fontColor('#000')
          .width(220)
          .onChange(() => {
            let mileage: number = parseFloat(this.textFir)
            let totalCarEmi: number =  parseFloat((mileage * item.carEmissionPer / 1000).toFixed(1))
            this.predictReduce = totalCarEmi
            console.log('bindSheet_first: '+ `${mileage}//${item.carEmissionPer}//${this.predictReduce}`)
          })
      }

      Row({ space: 10 }) {
        Image($r('app.media.BS_all_time'))
          .width(30)
          .fillColor('#37800f')
        Text('出行时长')
          .fontColor('#000')
          .fontSize(18)
        TextInput({ placeholder: '选填，单位：分钟', text: $$this.textSec })
          .placeholderColor('#ccc')
          .fontColor('#000')
          .width(220)
      }

      Divider()
        .color('#ccc')
        .strokeWidth(1)
        .width('100%')
        .padding({ left: 10, right: 10 })
        .vertical(false)

      Row({ space: 10 }) {
        Image($r('app.media.icon_leave'))
          .width(30)
          .fillColor('#37800f')
        Text('预估减排')
          .fontColor('#000')
          .fontSize(18)
        Text(this.predictReduce.toString())
          .fontColor('#000')
          .width(220)
      }

      Row({ space: 30 }) {
        Button('取消')
          .width('45%')
          .fontSize(18)
          .backgroundColor('#ffa90000')
          .fontColor('#fff')
          .onClick(() => {
            this.textFir = ''
            this.textSec = ''
            this.isShow = false
          })
        Button('确定')
          .width('45%')
          .fontSize(18)
          .backgroundColor('#37800f')
          .fontColor('#fff')
          .onClick(() => {
            let acc: string = AppStorage.get('currLoginAcc') as string
            let mileage: number = parseFloat(this.textFir)
            let totalCarEmi: number = parseFloat((mileage * item.carEmissionPer / 1000).toFixed(1))
            let tripTime: number = this.textSec === '' ? 0 : parseFloat(this.textSec)
            GreenTVM.insertItemData(item.ts, totalCarEmi, mileage, tripTime)
            GreenTVM.setCarEmiData(totalCarEmi)
            GreenTVM.setCarEmiDay()
            GreenTVM.setOutDistance(mileage)
            GreenTVM.setPoint(item.pointsPerOrder)
            setTimeout(() => {
              GreenTVM.updateTotalData(acc)
            }, 500)
            this.isShow = false
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(15)
    }
    .padding(15)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
  }

  @Builder
  bindSheet_second(index: number, item: transportsTypeModel) {
    Column({ space: 25 }) {
      Row({ space: 10 }) {
        Image($r('app.media.BS_sec_appliance'))
          .width(30)
          .fillColor('#37800f')
        Text('电器类型')
          .fontColor('#000')
          .fontSize(18)
        Text(this.funcList[index].ts)
          .fontColor('#000')
          .fontSize(16)
          .width('65%')
          .textAlign(TextAlign.End)
          .padding({ right: 15 })
      }

      Row({ space: 10 }) {
        Image($r('app.media.BS_all_time'))
          .width(30)
          .fillColor('#37800f')
        Text('使用时长')
          .fontColor('#000')
          .fontSize(18)
        TextInput({ placeholder: '请输入时长(小时)', text: $$this.textFir })
          .placeholderColor('#ccc')
          .fontColor('#000')
          .width(220)
      }

      Row({ space: 10 }) {
        Image($r('app.media.BS_sec_power'))
          .width(30)
          .fillColor('#37800f')
        Text('用电功率')
          .fontColor('#000')
          .fontSize(18)
        TextInput({ placeholder: '选填，单位：瓦(W)', text: $$this.textSec })
          .placeholderColor('#ccc')
          .fontColor('#000')
          .width(220)
      }

      Divider()
        .color('#ccc')
        .strokeWidth(1)
        .width('100%')
        .padding({ left: 10, right: 10 })
        .vertical(false)

      Row({ space: 10 }) {
        Image($r('app.media.icon_leave'))
          .width(30)
          .fillColor('#37800f')
        Text('预估减排')
          .fontColor('#000')
          .fontSize(18)
        TextInput({ placeholder: '单位：g/h', text: $$this.predictReduce })
          .placeholderColor('#ccc')
          .fontColor('#000')
          .width(220)
      }

      Row({ space: 30 }) {
        Button('取消')
          .width('45%')
          .fontSize(18)
          .backgroundColor('#ffa90000')
          .fontColor('#fff')
          .onClick(() => {
            this.textFir = ''
            this.textSec = ''
            this.isShow = false
          })
        Button('确定')
          .width('45%')
          .fontSize(18)
          .backgroundColor('#37800f')
          .fontColor('#fff')
          .onClick(() => {
            this.isShow = false
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(15)
    }
    .padding(15)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
  }

  @Builder
  bindSheet_third(index: number, item: transportsTypeModel) {
    Column({ space: 25 }) {
      Row({ space: 10 }) {
        Image($r('app.media.BS_ird_food'))
          .width(30)
          .fillColor('#37800f')
        Text('饮食类型')
          .fontColor('#000')
          .fontSize(18)
        Text(this.funcList[index].ts)
          .fontColor('#000')
          .fontSize(16)
          .width('65%')
          .textAlign(TextAlign.End)
          .padding({ right: 15 })
      }

      Row({ space: 10 }) {
        Image($r('app.media.BS_ird_num'))
          .width(30)
          .fillColor('#37800f')
        Text('食用份量')
          .fontColor('#000')
          .fontSize(18)
        TextInput({ placeholder: '请输入份量(g/份)', text: $$this.textFir })
          .placeholderColor('#ccc')
          .fontColor('#000')
          .width(220)
      }

      Row({ space: 10 }) {
        Image($r('app.media.BS_all_time'))
          .width(30)
          .fillColor('#37800f')
        Text('食用时长')
          .fontColor('#000')
          .fontSize(18)
        TextInput({ placeholder: '选填，单位：分钟', text: $$this.textSec })
          .placeholderColor('#ccc')
          .fontColor('#000')
          .width(220)
      }

      Divider()
        .color('#ccc')
        .strokeWidth(1)
        .width('100%')
        .padding({ left: 10, right: 10 })
        .vertical(false)

      Row({ space: 10 }) {
        Image($r('app.media.icon_leave'))
          .width(30)
          .fillColor('#37800f')
        Text('预估减排')
          .fontColor('#000')
          .fontSize(18)
        TextInput({ placeholder: '单位：g/g', text: $$this.predictReduce })
          .placeholderColor('#ccc')
          .fontColor('#000')
          .width(220)
      }

      Row({ space: 30 }) {
        Button('取消')
          .width('45%')
          .fontSize(18)
          .backgroundColor('#ffa90000')
          .fontColor('#fff')
          .onClick(() => {
            this.textFir = ''
            this.textSec = ''
            this.isShow = false
          })
        Button('确定')
          .width('45%')
          .fontSize(18)
          .backgroundColor('#37800f')
          .fontColor('#fff')
          .onClick(() => {
            this.isShow = false
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(15)
    }
    .padding(15)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
  }

  @Builder
  myBuilder(item: transportsTypeModel, index: number) {
    Column() {
      Row() {
        if (this.index_page === 1) {
          Text('选择出行详情')
            .fontSize(22)
            .fontWeight(600)
            .fontColor('#000')
        } else if (this.index_page === 2) {
          Text('选择用电详情')
            .fontSize(20)
            .fontWeight(600)
            .fontColor('#000')
        } else if (this.index_page === 3) {
          Text('选择饮食详情')
            .fontSize(20)
            .fontWeight(600)
            .fontColor('#000')
        }

        Image($r('app.media.arrow_up'))
          .padding(10)
          .width(40)
          .borderRadius(22)
          .backgroundColor('#ffe3e3e3')
          .fillColor('#000')
          .rotate({
            angle: 180
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(15)
      .onClick(() => {
        this.isShow = false
      })

      if (this.index_page === 1) {
        this.bindSheet_first(index, item)
      } else if (this.index_page === 2) {
        this.bindSheet_second(index, item)
      } else if (this.index_page === 3) {
        this.bindSheet_third(index, item)
      }
    }
  }

  @Builder
  funcListBuilder(item: transportsTypeModel, index: number) {
    Column({ space: 5 }) {
      Row() {
        Image(item.img)
          .width(30)
          .fillColor(item.tsc)
      }
      .width(50)
      .height(50)
      .padding(10)
      .backgroundColor(item.bgc)
      .borderRadius(20)


      Text(item.ts)
        .fontColor('#000')
        .fontSize(14)
    }
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#000')
        .margin({ bottom: 20 })

      Grid() {
        ForEach(this.funcList, (item: transportsTypeModel, index: number) => {
          GridItem() {
            this.funcListBuilder(item, index)
          }
          .onClick(() => {
            this.isShow = !this.isShow
            this.currIndex = index
          })
        })
      }
      .height(280)
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .columnsGap(15)
      .rowsGap(10)
      .bindSheet($$this.isShow, this.myBuilder(this.funcList[this.currIndex], this.currIndex), {
        height: this.sheetHeight,
        backgroundColor: Color.White,
        showClose: false,
        onWillAppear: () => {
          console.info("BindSheet onWillAppear.");
          this.isShow = true
        },
        onAppear: () => {
          console.info("BindSheet onAppear.");
        },
        onWillDisappear: () => {
          console.info("BindSheet onWillDisappear.");
          this.isShow = false
          this.textFir = ''
          this.textSec = ''
          this.predictReduce = 0
        },
        onDisappear: () => {
          console.info("BindSheet onDisappear.");
        }
      })
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .padding(15)
    .width('92%')
    .height(340)
    .margin({ left: 15, right: 15, top: 15 })
    .borderRadius(20)
    .backgroundColor('#fffafafa')
    .border({ width: 1, color: '#ffeeeeee' })
  }
}