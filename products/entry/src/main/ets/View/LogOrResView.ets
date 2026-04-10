import { BuilderNameConstants, buildRouterModel, RouterNameConstants } from "@ohos/customrouter"
import {
  AccJWTPreference,
  CarEmiApplianceTable,
  CarEmiFoodTable,
  CarEmiTotalWeeklyTable,
  CarEmiTransTable,
  HealthyNewsPreference,
  HTTPForCarCircle,
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
  // 上半区域动画状态
  @State floatLeaf1Y: number = 0
  @State floatLeaf2Y: number = 0
  @State floatLeaf3Y: number = 0
  @State leafRotation: number = 0
  @State particleOpacity: number = 0
  @State glowIntensity: number = 0
  // 验证相关状态
  @State accountError: string = ''
  @State passwordError: string = ''
  @State isSubmitting: boolean = false
  private accJWTPre: AccJWTPreference = AccJWTPreference.getInstance()
  private healthyNewsPre: HealthyNewsPreference = HealthyNewsPreference.getInstance()
  private httpForHN: HTTPForHealthyNews = HTTPForHealthyNews.getInstance()
  private httpForCarCir: HTTPForCarCircle = HTTPForCarCircle.getInstance()
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

    // 启动上半区域动画
    this.startUpperAnimation()
  }

  // 上半区域动画方法
  startUpperAnimation() {
    // 叶子浮动动画
    setInterval(() => {
      animateTo({
        duration: 3000,
        curve: Curve.EaseInOut
      }, () => {
        this.floatLeaf1Y = Math.random() * 40 - 20
      })
    }, 3000)

    setInterval(() => {
      animateTo({
        duration: 3500,
        curve: Curve.EaseInOut
      }, () => {
        this.floatLeaf2Y = Math.random() * 30 - 15
      })
    }, 3500)

    setInterval(() => {
      animateTo({
        duration: 4000,
        curve: Curve.EaseInOut
      }, () => {
        this.floatLeaf3Y = Math.random() * 50 - 25
      })
    }, 4000)

    // 叶子旋转动画
    setInterval(() => {
      animateTo({
        duration: 20000,
        curve: Curve.Linear
      }, () => {
        this.leafRotation += 360
      })
    }, 20000)

    // 粒子淡入动画
    setTimeout(() => {
      animateTo({
        duration: 1000,
        curve: Curve.EaseOut
      }, () => {
        this.particleOpacity = 0.6
      })
    }, 500)

    // 光脉动动画
    setInterval(() => {
      animateTo({
        duration: 2000,
        curve: Curve.EaseInOut,
        iterations: -1,
        playMode: PlayMode.Alternate
      }, () => {
        this.glowIntensity = 1
      })
    }, 2000)
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
    Stack({ alignContent: Alignment.TopStart }) {
      // 3. 内容区域容器（白色卡片，确保输入清晰）
      Column() {
        // 页面内容容器
        Column() {
          // 标题区域（在白色背景下使用深绿色保持协调）
          Column() {
            Text('登录 / 注册')
              .fontSize(26)
              .fontWeight(FontWeight.Bold)
              .fontColor('#0A5C36')  // 深绿色，与主题协调
              .margin({ bottom: 8 })

            Text('开启您的碳足迹之旅')
              .fontSize(14)
              .fontColor('#1B5E3A')  // 中等绿色
              .opacity(0.9)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .margin({ bottom: 35 })

          // 账号输入框
          Column() {
            Row() {
              Image($r('app.media.log_account'))
                .width(25)
                .fillColor(this.isAccountFocused ? $r('app.color.logOrRes_button_background') :
                  $r('app.color.logOrRes_button_border'))
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
              color: this.isAccountFocused ? $r('app.color.logOrRes_button_background') :
                $r('app.color.logOrRes_button_border'),
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
                .fillColor(this.isPasswordFocused ? $r('app.color.logOrRes_button_background') :
                  $r('app.color.logOrRes_button_border'))
                .animation({ duration: 200, curve: Curve.EaseOut })

              TextInput({ placeholder: '请输入密码', text: $$this.passwordStr })
                .width(275)
                .placeholderColor($r('app.color.logOrRes_button_word_a'))
                .fontColor($r('app.color.logOrRes_button_word_c'))
                .passwordIcon({
                  onIconSrc: $r('app.media.log_secret'),
                  offIconSrc: $r('app.media.log_secret_selected')
                })
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
              color: this.isPasswordFocused ? $r('app.color.logOrRes_button_background') :
                $r('app.color.logOrRes_button_border'),
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
              if (this.isSubmitting) {
                return
              }

              // 表单验证
              if (!this.validateForm()) {
                return
              }

              this.isSubmitting = true
              this.loginButtonText = '登录中...'

              // 这里可以调用实际的登录API
              this.httpForLoginState.setExtraData(this.accountStr, this.passwordStr, '1')
              await this.httpForLoginState.HTTPFunc()

              // 模拟登录过程
              setTimeout(async () => {
                if (this.httpForLoginState.isOK === false) {
                  this.getUIContext().getPromptAction().showToast({
                    message: '登录或注册出错',
                    duration: 1500,
                    bottom: 80
                  })
                } else {
                  const date = new Date().toLocaleDateString()
                  const JWT = this.httpForLoginState.returnJWT
                  AppStorage.set('currLoginAcc', this.accountStr)
                  this.accJWTPre.setCurrAccJWT(this.accountStr, JWT)
                  this.httpForCarCir.setJWT(JWT)

                  const bol_acc: boolean = await this.userRdbStoreIns.hasAcc(this.accountStr)
                  const bol_totalData: boolean = await this.carEmiTotalWeeklyTable.hasTodayItem(this.accountStr, date)
                  const bol_TaskData: boolean = await this.tendTasksTable.hasTodayItem(this.accountStr, date)
                  if (!bol_acc) {
                    this.userRdbStoreIns.setOriginalData(this.accountStr)
                    this.carEmiTransTableIns.setOriginalTotalData(this.accountStr)
                    this.carEmiApplianceTable.setOriginalTotalData(this.accountStr)
                    this.carEmiFoodTable.setOriginalTotalData(this.accountStr)
                  }
                  if (!bol_totalData) {
                    this.carEmiTotalWeeklyTable.setOriginalTotalData(this.accountStr, date)
                  }
                  if (!bol_TaskData) {
                    this.tendTasksTable.setOriginalTotalData(this.accountStr, date)
                  }

                  this.isLogin = true
                  this.healthyNewsPre.setTodayData_HN(this.httpForHN.data)
                  this.loginProgressBol = false
                  this.isSubmitting = false
                  console.log('数据：' + this.accountStr + ';;' + this.httpForLoginState.returnUserName)
                }

                this.loginButtonText = $r('app.string.logOrRes_button')
                this.isSubmitting = false
              }, 1500)
            })

          // 游客登录按钮（文字按钮样式）
          Text('游客体验')
            .fontColor($r('app.color.logOrRes_button_word_b'))
            .fontSize(15)
            .margin({ top: 20 })
            .onClick(async () => {
              if (this.isSubmitting) {
                return
              }

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
        }
        .width('100%')
        .padding({ top: 30, bottom: 50 })
      }
      .opacity(this.pageOpacity)
      .translate({ y: this.pageTranslateY })
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF') // 确保内容区域纯白
      .borderRadius({ topLeft: 40, topRight: 40 })
      .shadow({
        radius: 20,
        type: ShadowType.COLOR,
        color: '#00000020',
        offsetY: -5
      })
      .margin({ top: '15%' }) // 给上半区域动画留出空间，但确保输入区域可见
    }
    .width('100%')
    .height(650)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}