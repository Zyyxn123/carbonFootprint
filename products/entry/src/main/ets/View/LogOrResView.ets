import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"
import {
  CarEmiApplianceTable,
  CarEmiFoodTable,
  CarEmiTotalWeeklyTable,
  CarEmiTransTable,
  HealthyNewsPreference,
  HTTPForHealthyNews,
  HTTPForLoginState,
  TendTasksTable,
  UserRdbStore
} from "@ohos/utils"
import { common } from "@kit.AbilityKit"
import prompt from '@ohos.prompt'

@Component
export struct logOrResView {
  @State accountStr: string = ''
  @State passwordStr: string = ''
  @State loginProgressBol: boolean = false
  @Link isLogin: boolean

  // 动画相关状态
  @State isAccountFocused: boolean = false
  @State isPasswordFocused: boolean = false
  @State buttonScale: number = 1
  @State pageOpacity: number = 0
  @State pageTranslateY: number = 30
  @State loginButtonText: ResourceStr = $r('app.string.logOrRes_button')

  // 验证相关状态
  @State accountError: string = ''
  @State passwordError: string = ''
  @State isSubmitting: boolean = false

  private healthyNewsPre: HealthyNewsPreference = HealthyNewsPreference.getInstance()
  private httpForHN: HTTPForHealthyNews = HTTPForHealthyNews.getInstance()
  private userRdbStoreIns: UserRdbStore = UserRdbStore.getInstance()
  private carEmiTransTableIns: CarEmiTransTable = CarEmiTransTable.getInstance()
  private carEmiApplianceTable: CarEmiApplianceTable = CarEmiApplianceTable.getInstance()
  private carEmiFoodTable: CarEmiFoodTable = CarEmiFoodTable.getInstance()
  private carEmiTotalWeeklyTable: CarEmiTotalWeeklyTable = CarEmiTotalWeeklyTable.getInstance()
  private tendTasksTable: TendTasksTable = TendTasksTable.getInstance()
  private httpForLoginState: HTTPForLoginState = HTTPForLoginState.getInstance()
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext
  private isSelected: boolean = false

  aboutToAppear() {
    // 页面进入动画
    animateTo({
      duration: 400,
      curve: Curve.EaseOut
    }, () => {
      this.pageOpacity = 1
      this.pageTranslateY = 0
    })
  }

  // 表单验证方法
  validateForm(): boolean {
    let isValid = true

    // 重置错误信息
    this.accountError = ''
    this.passwordError = ''

    // 验证账号
    if (this.accountStr.length === 0) {
      this.accountError = '请输入账号'
      isValid = false
    } else if (this.accountStr.length < 3) {
      this.accountError = '账号至少3个字符'
      isValid = false
    }

    // 验证密码
    if (this.passwordStr.length === 0) {
      this.passwordError = '请输入密码'
      isValid = false
    } else if (this.passwordStr.length < 6) {
      this.passwordError = '密码至少6个字符'
      isValid = false
    }

    return isValid
  }

  // 按钮点击动画
  startButtonAnimation() {
    animateTo({ duration: 100 }, () => {
      this.buttonScale = 0.95
    })
  }

  resetButtonAnimation() {
    animateTo({ duration: 100 }, () => {
      this.buttonScale = 1
    })
  }

  build() {
    Column() {
      // 页面内容容器
      Column() {
        // 标题区域
        Column() {
          Text('碳迹')
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.logOrRes_button_background'))
            .margin({ bottom: 8 })

          Text('记录您的碳足迹，共建绿色地球')
            .fontSize(14)
            .fontColor($r('app.color.logOrRes_button_word_a'))
            .opacity(0.8)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin({ bottom: 40 })

        // 账号输入框
        Column() {
          Row() {
            Image($r('app.media.log_account'))
              .width(25)
              .fillColor(this.isAccountFocused ? $r('app.color.logOrRes_button_background') : $r('app.color.logOrRes_button_border'))
              .animation({ duration: 200, curve: Curve.EaseOut })

            TextInput({ placeholder: '请输入账号', text: $$this.accountStr })
              .backgroundColor(Color.Transparent)
              .width(260)
              .placeholderColor($r('app.color.logOrRes_button_word_a'))
              .fontColor($r('app.color.logOrRes_button_word_c'))
              .copyOption(CopyOptions.LocalDevice)
              .onFocus(() => {
                animateTo({ duration: 200 }, () => {
                  this.isAccountFocused = true
                })
              })
              .onBlur(() => {
                animateTo({ duration: 200 }, () => {
                  this.isAccountFocused = false
                })
                // 失去焦点时验证
                if (this.accountStr.length > 0 && this.accountStr.length < 3) {
                  this.accountError = '账号至少3个字符'
                }
              })
          }
          .width('100%')
          .height(50)
          .border({
            radius: 25,
            color: this.isAccountFocused ? $r('app.color.logOrRes_button_background') : $r('app.color.logOrRes_button_border'),
            width: this.isAccountFocused ? 3 : 2
          })
          .padding({ left: 12 })
          .animation({ duration: 200, curve: Curve.EaseOut })

          // 账号错误提示
          if (this.accountError) {
            Text(this.accountError)
              .fontSize(12)
              .fontColor(Color.Red)
              .margin({ top: 4, left: 12 })
              .width('100%')
              .textAlign(TextAlign.Start)
              .transition({ type: TransitionType.Insert, opacity: 0.5 })
          }
        }
        .width('85%')

        // 密码输入框
        Column() {
          Row() {
            Image($r('app.media.log_password'))
              .width(25)
              .fillColor(this.isPasswordFocused ? $r('app.color.logOrRes_button_background') : $r('app.color.logOrRes_button_border'))
              .animation({ duration: 200, curve: Curve.EaseOut })

            TextInput({ placeholder: '请输入密码', text: $$this.passwordStr })
              .width(275)
              .placeholderColor($r('app.color.logOrRes_button_word_a'))
              .fontColor($r('app.color.logOrRes_button_word_c'))
              .passwordIcon({ onIconSrc: $r('app.media.log_secret'), offIconSrc: $r('app.media.log_secret_selected') })
              .type(InputType.Password)
              .backgroundColor(Color.Transparent)
              .copyOption(CopyOptions.LocalDevice)
              .onFocus(() => {
                animateTo({ duration: 200 }, () => {
                  this.isPasswordFocused = true
                })
              })
              .onBlur(() => {
                animateTo({ duration: 200 }, () => {
                  this.isPasswordFocused = false
                })
                // 失去焦点时验证
                if (this.passwordStr.length > 0 && this.passwordStr.length < 6) {
                  this.passwordError = '密码至少6个字符'
                }
              })
          }
          .width('100%')
          .height(50)
          .border({
            radius: 25,
            color: this.isPasswordFocused ? $r('app.color.logOrRes_button_background') : $r('app.color.logOrRes_button_border'),
            width: this.isPasswordFocused ? 3 : 2
          })
          .padding({ left: 12, right: 12 })
          .margin({ top: 25 })
          .animation({ duration: 200, curve: Curve.EaseOut })

          // 密码错误提示
          if (this.passwordError) {
            Text(this.passwordError)
              .fontSize(12)
              .fontColor(Color.Red)
              .margin({ top: 4, left: 12 })
              .width('100%')
              .textAlign(TextAlign.Start)
              .transition({ type: TransitionType.Insert, opacity: 0.5 })
          }
        }
        .width('85%')
        .margin({ bottom: 12 })

        // 忘记密码
        Text($r('app.string.logOrRes_forgetPsw'))
          .fontColor($r('app.color.logOrRes_button_word_b'))
          .width('85%')
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Medium)
          .fontSize(15)
          .margin({ top: 8 })
          .onClick(() => {
            // 忘记密码逻辑
          })

        // 登录/注册按钮
        Button(this.loginButtonText)
          .fontSize(17)
          .fontColor($r('app.color.logOrRes_button_word'))
          .backgroundColor($r('app.color.logOrRes_button_background'))
          .width('85%')
          .height(50)
          .margin({ top: 30 })
          .borderRadius(25)
          .stateEffect(true)
          .scale({ x: this.buttonScale, y: this.buttonScale })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.startButtonAnimation()
            } else if (event.type === TouchType.Up) {
              this.resetButtonAnimation()
            }
          })
          .onClick(async () => {
            // if (this.isSubmitting) return
            //
            // // 表单验证
            // if (!this.validateForm()) {
            //   return
            // }
            //
            // this.isSubmitting = true
            // this.loginButtonText = '登录中...'
            //
            // // 这里可以调用实际的登录API
            // // this.httpForLoginState.setExtraData(this.accountStr, this.passwordStr, '1')
            // // await this.httpForLoginState.HTTPFunc()
            //
            // // 模拟登录过程
            // setTimeout(() => {
            //   this.loginButtonText = $r('app.string.logOrRes_button')
            //   this.isSubmitting = false
            //
            //   // 这里可以添加实际登录成功后的逻辑
            //   prompt.showToast({
            //     message: '登录成功（模拟）',
            //     duration: 2000
            //   })
            // }, 1500)
          })

        // 游客登录按钮（文字按钮样式）
        Text('游客体验')
          .fontColor($r('app.color.logOrRes_button_word_b'))
          .fontSize(15)
          .margin({ top: 20 })
          .onClick(async () => {
            if (this.isSubmitting) return

            this.isSubmitting = true
            this.loginProgressBol = true

            // 保持原有的游客登录逻辑不变
            let date = new Date().toLocaleDateString()
            AppStorage.set('currLoginAcc', 'testDemo')
            const bol_acc: boolean = await this.userRdbStoreIns.hasAcc('testDemo')
            const bol_totalData: boolean = await this.carEmiTotalWeeklyTable.hasTodayItem('testDemo', date)
            const bol_TaskData: boolean = await this.tendTasksTable.hasTodayItem('testDemo', date)
            if (!bol_acc) {
              this.userRdbStoreIns.setOriginalData('testDemo')
              this.carEmiTransTableIns.setOriginalTotalData('testDemo')
              this.carEmiApplianceTable.setOriginalTotalData('testDemo')
              this.carEmiFoodTable.setOriginalTotalData('testDemo')
            }
            if (!bol_totalData) {
              this.carEmiTotalWeeklyTable.setOriginalTotalData('testDemo', date)
            }
            if (!bol_TaskData) {
              this.tendTasksTable.setOriginalTotalData('testDemo', date)
            }

            // 添加登录成功动画
            animateTo({ duration: 300 }, () => {
              this.pageOpacity = 0
              this.pageTranslateY = -30
            })

            setTimeout(() => {
              this.isLogin = true
              this.healthyNewsPre.setTodayData_HN(this.httpForHN.data)
              this.loginProgressBol = false
              this.isSubmitting = false
            }, 300)
          })

        // 加载状态
        if (this.loginProgressBol) {
          Column() {
            LoadingProgress()
              .color($r('app.color.logOrRes_button_background'))
              .width(50)
              .height(50)

            Text(this.isLogin ? '正在跳转...' : '登录中...')
              .fontSize(12)
              .fontColor($r('app.color.logOrRes_button_word_a'))
              .margin({ top: 10 })
          }
          .transition({ type: TransitionType.Insert, opacity: 0.5 })
          .margin({ top: 30 })
        }

        // 调试按钮（仅开发环境显示）
        // Button('删除数据库')
        //   .fontSize(12)
        //   .fontColor(Color.Gray)
        //   .margin({ top: 20 })
        //   .onClick(() => {
        //     this.userRdbStoreIns.deleteMyTable()
        //     this.carEmiTransTableIns.deleteMyTable()
        //     this.carEmiApplianceTable.deleteMyTable()
        //     this.carEmiFoodTable.deleteMyTable()
        //     this.carEmiTotalWeeklyTable.deleteMyTable()
        //     this.tendTasksTable.deleteMyTable()
        //   })
      }
      .width('100%')
      .padding({ top: 40, bottom: 40 })
    }
    .opacity(this.pageOpacity)
    .translate({ y: this.pageTranslateY })
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('72%')
    .backgroundColor($r('app.color.logOrRes_background_fore'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .borderRadius({ topLeft: 25, topRight: 25 })
    .shadow({ radius: 30, type: ShadowType.COLOR, color: $r('app.color.logOrRes_shadow'), offsetY: -5 })
    .linearGradient({
      angle: 180,
      colors: [
        [$r('app.color.logOrRes_background_fore'), 0.0],
        [$r('app.color.logOrRes_background_fore'), 0.8],
        [$r('app.color.logOrRes_background'), 1.0]
      ]
    })
  }
}