import { basicData } from "../View/BasicData"
import { commonTools } from "../View/CommonTools"
import { faceCards } from "../View/FaceCards"


@Component
export struct Mine_homePage {
  build() {
    Column() {
      basicData()

      Column() {
        faceCards()
        commonTools()
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 20, topRight: 20})
      .border({ width: 1, color: '#cccccc'})
    }
    .width('100%')
    .height('100%')
  }
}

// #5b9953 #6fad66 #87ba80 #9fc899 #b7d6b3 #cfe4cc #e7f1e6
// #42703c #396034 #2f502b #264022 #1c301a #132011 #091009