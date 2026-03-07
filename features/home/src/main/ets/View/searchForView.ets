@Component
export struct searchForView {
  @State searchStr: string = ''

  build() {
    Row({ space: 10 }) {
      Text($r('app.string.searchView_carbonEmission'))
        .fontColor($r('app.color.searchFor_carbonEmission_color'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      Row() {
        Image($r('app.media.search_magnifier'))
          .width(25)
          .fillColor($r('app.color.searchFor_magnifier_color'))

        TextInput({ placeholder: $r('app.string.searchView_placeholder'), text: $$this.searchStr })
          .backgroundColor(Color.Transparent)
          .placeholderColor($r('app.color.searchFor_placeholder_color'))
          .width(240)
      }
      .border({ width: 1, color: $r('app.color.searchFor_border_color'), radius: 25 })
      .padding({ left: 10})
    }
    .width('100%')
    .padding({ left: 10, right: 10})
  }
}