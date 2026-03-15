import { transportsTypeModel } from "../Model/ToDoItemsModel"

@Component
export struct funcListsSelectedMap {
  @State isShow: boolean = false
  @Prop index_page: number
  @Prop funcList: transportsTypeModel[]
  @Prop title: string
  private sheetHeight: number = 500

  @Builder
  bindSheet_first(item: transportsTypeModel, index: number) {
  }

  @Builder
  bindSheet_second(item: transportsTypeModel, index: number) {
  }

  @Builder
  bindSheet_third(item: transportsTypeModel, index: number) {
  }

  @Builder
  myBuilder(item: transportsTypeModel, index: number) {
    Column() {
      Row() {
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
      .justifyContent(FlexAlign.End)
      .width('100%')
      .padding(15)
      .onClick(() => {
        this.isShow = false
      })

      if (this.index_page === 1) {
        this.bindSheet_first(item, index)
      } else if (this.index_page === 2) {
        this.bindSheet_second(item, index)
      } else if (this.index_page === 3) {
        this.bindSheet_third(item, index)
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
      .onClick(() => {
        this.isShow = !this.isShow
      })
      .bindSheet($$this.isShow, this.myBuilder(item, index), {
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
        },
        onDisappear: () => {
          console.info("BindSheet onDisappear.");
        }
      })

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
        })
      }
      .height(280)
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .columnsGap(15)
      .rowsGap(10)
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