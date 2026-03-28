@Component
export struct backgroundAndIpView {
  // 主logo动画状态
  @State logoScale: number = 0.8
  @State logoOpacity: number = 0
  @State logoRotation: number = -5
  @State logoGlow: number = 0
  // 浮动元素动画状态
  @State floatOffset1: number = 0
  @State floatOffset2: number = 0
  @State floatOffset3: number = 0
  @State floatOpacity: number = 0
  // 文字动画状态
  @State titleOpacity: number = 0
  @State titleTranslateY: number = 30
  @State titleScale: number = 0.9
  @State subtitleOpacity: number = 0
  @State subtitleTranslateY: number = 20
  @State taglineOpacity: number = 0
  @State taglineTranslateY: number = 20
  // 装饰元素状态
  @State decorationScale: number = 0
  @State decorationOpacity: number = 0
  @State decorationRotation: number = 0

  // Canvas动画状态
  @State canvasAnimationTime: number = 0
  @State canvasRotation: number = 0
  @State canvasPulse: number = 0
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D()
  private animationId: number = 0
  private canvasWidth: number = 200
  private canvasHeight: number = 200

  aboutToAppear() {
    // 初始化浮动动画
    this.startFloatingAnimation()

    // 主logo入场动画序列
    setTimeout(() => {
      animateTo({
        duration: 800,
        curve: Curve.EaseOut
      }, () => {
        this.logoScale = 1
        this.logoOpacity = 1
        this.logoRotation = 0
      })
    }, 200)

    // logo光晕动画
    setTimeout(() => {
      animateTo({
        duration: 1500,
        curve: Curve.EaseInOut,
        iterations: -1, // 无限循环
        playMode: PlayMode.Alternate
      }, () => {
        this.logoGlow = 1
      })
    }, 1000)

    // 浮动元素淡入
    setTimeout(() => {
      animateTo({
        duration: 600,
        curve: Curve.EaseOut
      }, () => {
        this.floatOpacity = 0.4
      })
    }, 400)

    // 标题动画
    setTimeout(() => {
      animateTo({
        duration: 900,
        curve: Curve.EaseInOut
      }, () => {
        this.titleOpacity = 1
        this.titleTranslateY = 0
        this.titleScale = 1
      })
    }, 700)

    // 副标题动画
    setTimeout(() => {
      animateTo({
        duration: 700,
        curve: Curve.EaseOut
      }, () => {
        this.subtitleOpacity = 1
        this.subtitleTranslateY = 0
      })
    }, 1000)

    // 标语动画
    setTimeout(() => {
      animateTo({
        duration: 700,
        curve: Curve.EaseOut
      }, () => {
        this.taglineOpacity = 1
        this.taglineTranslateY = 0
      })
    }, 1300)

    // 装饰元素动画
    setTimeout(() => {
      animateTo({
        duration: 1200,
        curve: Curve.EaseInOut
      }, () => {
        this.decorationScale = 1
        this.decorationOpacity = 0.8
      })
    }, 1500)

    // 装饰旋转动画
    setInterval(() => {
      animateTo({
        duration: 20000,
        curve: Curve.Linear
      }, () => {
        this.decorationRotation += 360
      })
    }, 20000)
  }

  // 浮动动画
  startFloatingAnimation() {
    // 元素1浮动
    setInterval(() => {
      animateTo({
        duration: 4000,
        curve: Curve.EaseInOut
      }, () => {
        this.floatOffset1 = Math.random() * 30 - 15
      })
    }, 4000)

    // 元素2浮动
    setInterval(() => {
      animateTo({
        duration: 3500,
        curve: Curve.EaseInOut
      }, () => {
        this.floatOffset2 = Math.random() * 40 - 20
      })
    }, 3500)

    // 元素3浮动
    setInterval(() => {
      animateTo({
        duration: 4500,
        curve: Curve.EaseInOut
      }, () => {
        this.floatOffset3 = Math.random() * 25 - 12.5
      })
    }, 4500)
  }

  aboutToDisappear() {
    // 停止Canvas动画
    if (this.animationId) {
      clearInterval(this.animationId)
    }
  }

  // Canvas动画循环
  startCanvasAnimation() {
    this.animationId = setInterval(() => {
      this.canvasAnimationTime += 0.05
      this.canvasRotation += 1
      this.canvasPulse = 0.5 + 0.5 * Math.sin(this.canvasAnimationTime)

      // 请求重绘
      this.canvasContext.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
      this.drawCanvas()
    }, 16) // 约60fps
  }

  // Canvas绘制函数
  drawCanvas() {
    const ctx = this.canvasContext
    const centerX = this.canvasWidth / 2
    const centerY = this.canvasHeight / 2
    const time = this.canvasAnimationTime

    // 清除画布
    ctx.clearRect(0, 0, this.canvasWidth, this.canvasHeight)

    // 绘制多层光晕（优化后的优美光晕）
    for (let i = 0; i < 3; i++) {
      const radius = 60 + i * 20
      const opacity = 0.2 - i * 0.05
      const pulseFactor = 1 + 0.1 * Math.sin(time + i * 0.5)

      ctx.beginPath()
      ctx.arc(centerX, centerY, radius * pulseFactor, 0, Math.PI * 2)
      ctx.fillStyle = `rgba(76, 175, 80, ${opacity})`
      ctx.fill()

      // 外发光
      ctx.beginPath()
      ctx.arc(centerX, centerY, radius * pulseFactor + 10, 0, Math.PI * 2)
      ctx.strokeStyle = `rgba(255, 255, 255, ${opacity * 0.5})`
      ctx.lineWidth = 2
      ctx.stroke()
    }

    // 绘制抽象叶子形状
    ctx.save()
    ctx.translate(centerX, centerY)
    ctx.rotate(this.canvasRotation * Math.PI / 180)

    // 叶子主体
    ctx.beginPath()
    for (let i = 0; i < 8; i++) {
      const angle = (i * Math.PI) / 4
      const radius = 50 + 10 * Math.sin(time * 2 + i)
      const x = radius * Math.cos(angle)
      const y = radius * Math.sin(angle) * 0.7

      if (i === 0) {
        ctx.moveTo(x, y)
      } else {
        ctx.lineTo(x, y)
      }
    }
    ctx.closePath()

    // 叶子渐变填充
    const gradient = ctx.createLinearGradient(-50, -50, 50, 50)
    gradient.addColorStop(0, '#4CAF50')
    gradient.addColorStop(1, '#8BC34A')
    ctx.fillStyle = gradient
    ctx.fill()

    // 叶子描边
    ctx.strokeStyle = '#FFFFFF'
    ctx.lineWidth = 2
    ctx.stroke()

    // 叶子脉络
    ctx.beginPath()
    for (let i = 0; i < 4; i++) {
      const angle = (i * Math.PI) / 2
      const length = 40 + 5 * Math.sin(time * 3 + i)
      ctx.moveTo(0, 0)
      ctx.lineTo(length * Math.cos(angle), length * Math.sin(angle) * 0.7)
    }
    ctx.strokeStyle = '#FFFFFF'
    ctx.lineWidth = 1
    ctx.stroke()

    ctx.restore()

    // 绘制旋转粒子
    for (let i = 0; i < 12; i++) {
      const angle = (i * Math.PI) / 6 + time
      const distance = 80 + 10 * Math.sin(time * 2 + i * 0.5)
      const size = 3 + 2 * Math.sin(time * 3 + i)

      ctx.beginPath()
      ctx.arc(
        centerX + distance * Math.cos(angle),
        centerY + distance * Math.sin(angle),
        size,
        0,
        Math.PI * 2
      )
      ctx.fillStyle = `rgba(255, 255, 255, ${0.7 + 0.3 * Math.sin(time + i)})`
      ctx.fill()
    }
  }

  // Canvas onReady回调
  onCanvasReady(canvas: CanvasRenderingContext2D) {
    this.canvasContext = canvas
    this.startCanvasAnimation()
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 1. 主背景渐变
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 145,
          colors: [
            ['#0C3B2E', 0.0], // 深墨绿
            ['#1B5E3A', 0.3], // 森林绿
            [$r('app.color.logOrRes_button_background'), 0.6], // 主题绿
            ['#8BC34A', 0.9], // 浅绿
            ['#E8F5E9', 1.0]// 极浅绿
          ]
        })

      // 2. 浮动装饰元素（类似Lottie动画效果）
      // 浮动元素1 - 左上角
      Circle()
        .width(80)
        .height(80)
        .fill('#FFFFFF15')
        .position({ x: -20 + this.floatOffset1, y: '15%' })
        .opacity(this.floatOpacity)
        .shadow({ radius: 30, color: '#FFFFFF20' })

      // 浮动元素2 - 右上角
      Circle()
        .width(120)
        .height(120)
        .fill('#FFFFFF10')
        .position({ x: '85%', y: '10%' })
        .translate({ x: this.floatOffset2 })
        .opacity(this.floatOpacity)

      // 浮动元素3 - 左下角
      Circle()
        .width(60)
        .height(60)
        .fill('#FFFFFF20')
        .position({ x: '10%', y: '70%' })
        .translate({ y: this.floatOffset3 })
        .opacity(this.floatOpacity)

      // 3. 主要内容容器
      Column() {
        // 顶部留白区域
        Column()
          .height('15%')

        // Logo区域
        Stack({ alignContent: Alignment.Center }) {
          // 优化光晕背景 - 多层光环（颜色调淡）
          Stack({ alignContent: Alignment.Center }) {
            // 外层光晕
            Circle()
              .width(260)
              .height(260)
              .fill('#FFFFFF')
              .opacity(0.01 + this.logoGlow * 0.03)
              .shadow({
                radius: 80 + this.logoGlow * 40,
                color: '#4CAF50'
              })
              .scale({ x: this.decorationScale, y: this.decorationScale })
              .opacity(this.decorationOpacity)

            // 中层光晕
            Circle()
              .width(220)
              .height(220)
              .fill('#FFFFFF')
              .opacity(0.02 + this.logoGlow * 0.05)
              .shadow({
                radius: 50 + this.logoGlow * 25,
                color: '#8BC34A'
              })
              .scale({ x: this.decorationScale, y: this.decorationScale })
              .opacity(this.decorationOpacity * 0.6)

            // 内层光晕（透明度最低，不遮挡旋转光点）
            Circle()
              .width(180)
              .height(180)
              .fill('#FFFFFF')
              .opacity(0.008 + this.logoGlow * 0.02)
              .shadow({
                radius: 30 + this.logoGlow * 15,
                color: '#C8E6C9'
              })
              .scale({ x: this.decorationScale, y: this.decorationScale })
              .opacity(this.decorationOpacity * 0.2)
          }

          // 旋转装饰环
          Circle()
            .width(200)
            .height(200)
            .stroke('#FFFFFF40')
            .fill(Color.Transparent)
            .rotate({ angle: this.decorationRotation })
            .scale({ x: this.decorationScale, y: this.decorationScale })
            .opacity(this.decorationOpacity)

          // 主Logo - Canvas动画
          Canvas(this.canvasContext)
            .width(200)
            .height(200)
            .scale({ x: this.logoScale, y: this.logoScale })
            .rotate({ angle: this.logoRotation })
            .opacity(this.logoOpacity)
            .onReady(() => {
              this.onCanvasReady(this.canvasContext)
            })
        }
        .margin({ bottom: 50 })

        // 艺术化文字区域
        Column() {
          // 主标题 - 艺术字体效果
          Stack({ alignContent: Alignment.Center }) {
            // 背景发光效果
            Text('碳迹')
              .fontSize(48)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .shadow({
                radius: 20 + this.logoGlow * 10,
                color: '#4CAF50',
                offsetX: 0,
                offsetY: 0
              })
              .opacity(this.titleOpacity)
              .translate({ y: this.titleTranslateY })
              .scale({ x: this.titleScale, y: this.titleScale })

            // 主标题前景
            Text('碳迹')
              .fontSize(48)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .opacity(this.titleOpacity)
              .translate({ y: this.titleTranslateY })
              .scale({ x: this.titleScale, y: this.titleScale })
          }

          // 副标题区域
          Column() {
            // 第一行副标题 - 优雅小字
            Text('TRACE YOUR')
              .fontSize(14)
              .fontColor('#FFFFFF99')
              .letterSpacing(8)
              .opacity(this.subtitleOpacity)
              .translate({ y: this.subtitleTranslateY })
              .margin({ bottom: 8 })

            // 第二行副标题 - 强调
            Text('GREEN FOOTPRINT')
              .fontSize(22)
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .letterSpacing(2)
              .opacity(this.subtitleOpacity)
              .translate({ y: this.subtitleTranslateY })
              .margin({ bottom: 24 })

            // 装饰分隔线
            Row() {
              Column()
                .width(60)
                .height(1)
                .backgroundColor('#FFFFFF60')
                .margin({ right: 16 })

              // 中间图标 - 叶子形状
              Circle()
                .width(24)
                .height(24)
                .fill('#4CAF50')
                .opacity(this.taglineOpacity)
                .rotate({ angle: this.decorationRotation / 10 })
                .shadow({ radius: 5, color: '#FFFFFF60' })

              Column()
                .width(60)
                .height(1)
                .backgroundColor('#FFFFFF60')
                .margin({ left: 16 })
            }
            .alignItems(VerticalAlign.Center)
            .margin({ bottom: 24 })
            .opacity(this.taglineOpacity)

            // 标语
            Column() {
              Text('每一次选择')
                .fontSize(16)
                .fontColor('#FFFFFFDD')
                .opacity(this.taglineOpacity)
                .translate({ y: this.taglineTranslateY })

              Text('都是对地球的温柔承诺')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FFFFFF')
                .opacity(this.taglineOpacity)
                .translate({ y: this.taglineTranslateY })
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Center)
          }
          .alignItems(HorizontalAlign.Center)
          .margin({ top: 30 })
        }
        .alignItems(HorizontalAlign.Center)

        // 底部指示器
        Column() {
          // 滚动指示点
          Row() {
            ForEach([0, 1, 2], (index: number) => {
              Circle()
                .width(8)
                .height(8)
                .fill(index === 0 ? '#FFFFFF' : '#FFFFFF60')
                .margin({ right: 8 })
                .animation({
                  duration: 1000,
                  curve: Curve.EaseInOut,
                  delay: index * 200,
                  iterations: -1,
                  playMode: PlayMode.Alternate
                })
                .scale({
                  x: index === 0 ? 1 + this.logoGlow * 0.3 : 1,
                  y: index === 0 ? 1 + this.logoGlow * 0.3 : 1
                })
            })
          }
          .margin({ top: 60 })

          // 提示文字
          Text('向上滑动登录')
            .fontSize(12)
            .fontColor('#FFFFFF99')
            .margin({ top: 12 })
            .opacity(this.taglineOpacity)
        }
        .alignItems(HorizontalAlign.Center)

        // 底部留白
        Column()
          .height('10%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}