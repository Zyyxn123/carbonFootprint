/**
 * Canvas绘制工具类
 * 提供常用的Canvas绘制函数和效果
 */

export interface Particle {
  x: number;
  y: number;
  size: number;
  color: string;
  alpha: number;
  speed: number
}

export class CanvasUtils {
  // 绘制圆环进度条
  static drawRingProgress(
    ctx: CanvasRenderingContext2D,
    centerX: number,
    centerY: number,
    radius: number,
    lineWidth: number,
    progress: number, // 0-1
    startColor: string,
    endColor: string,
    backgroundColor: string = 'rgba(255, 255, 255, 0.1)'
  ): void {
    // 清除区域
    ctx.clearRect(centerX - radius - lineWidth, centerY - radius - lineWidth,
      radius * 2 + lineWidth * 2, radius * 2 + lineWidth * 2)

    // 绘制背景圆环
    ctx.beginPath()
    ctx.arc(centerX, centerY, radius, 0, Math.PI * 2)
    ctx.lineWidth = lineWidth
    ctx.strokeStyle = backgroundColor
    ctx.stroke()

    // 绘制进度圆环
    const startAngle = -Math.PI / 2
    const endAngle = startAngle + (Math.PI * 2 * progress)

    // 创建渐变
    const gradient = ctx.createLinearGradient(
      centerX - radius, centerY,
      centerX + radius, centerY
    )
    gradient.addColorStop(0, startColor)
    gradient.addColorStop(1, endColor)

    ctx.beginPath()
    ctx.arc(centerX, centerY, radius, startAngle, endAngle)
    ctx.lineWidth = lineWidth
    ctx.strokeStyle = gradient
    ctx.lineCap = 'round'
    ctx.stroke()

    // 添加光晕效果
    ctx.shadowColor = startColor
    ctx.shadowBlur = 10
    ctx.stroke()
    ctx.shadowBlur = 0
  }

  // 绘制指针
  static drawPointer(
    ctx: CanvasRenderingContext2D,
    centerX: number,
    centerY: number,
    radius: number,
    pointerLength: number,
    angle: number, // 弧度
    color: string
  ): void {
    const pointerEndX = centerX + Math.cos(angle) * pointerLength
    const pointerEndY = centerY + Math.sin(angle) * pointerLength

    ctx.beginPath()
    ctx.moveTo(centerX, centerY)
    ctx.lineTo(pointerEndX, pointerEndY)
    ctx.lineWidth = 3
    ctx.strokeStyle = color
    ctx.lineCap = 'round'
    ctx.stroke()

    // 绘制指针圆点
    ctx.beginPath()
    ctx.arc(centerX, centerY, 5, 0, Math.PI * 2)
    ctx.fillStyle = color
    ctx.fill()
  }

  // 绘制动态光晕
  static drawGlow(
    ctx: CanvasRenderingContext2D,
    x: number,
    y: number,
    radius: number,
    color: string,
    intensity: number = 1.0
  ): void {
    const gradient = ctx.createRadialGradient(x, y, 0, x, y, radius)
    gradient.addColorStop(0, `${color}${Math.floor(0.5 * intensity * 255).toString(16).padStart(2, '0')}`)
    gradient.addColorStop(0.7, `${color}${Math.floor(0.2 * intensity * 255).toString(16).padStart(2, '0')}`)
    gradient.addColorStop(1, `${color}00`)

    ctx.beginPath()
    ctx.arc(x, y, radius, 0, Math.PI * 2)
    ctx.fillStyle = gradient
    ctx.fill()
  }

  // 绘制浮动粒子
  static drawParticles(
    ctx: CanvasRenderingContext2D,
    particles: Particle[]
  ): void {
    particles.forEach(particle => {
      ctx.beginPath()
      ctx.arc(particle.x, particle.y, particle.size, 0, Math.PI * 2)
      ctx.fillStyle = `${particle.color}${Math.floor(particle.alpha * 255).toString(16).padStart(2, '0')}`
      ctx.fill()
    })
  }

  // 绘制圆角矩形
  static drawRoundedRect(
    ctx: CanvasRenderingContext2D,
    x: number,
    y: number,
    width: number,
    height: number,
    radius: number,
    color: string
  ): void {
    ctx.beginPath()
    ctx.moveTo(x + radius, y)
    ctx.lineTo(x + width - radius, y)
    ctx.arcTo(x + width, y, x + width, y + radius, radius)
    ctx.lineTo(x + width, y + height - radius)
    ctx.arcTo(x + width, y + height, x + width - radius, y + height, radius)
    ctx.lineTo(x + radius, y + height)
    ctx.arcTo(x, y + height, x, y + height - radius, radius)
    ctx.lineTo(x, y + radius)
    ctx.arcTo(x, y, x + radius, y, radius)
    ctx.closePath()
    ctx.fillStyle = color
    ctx.fill()
  }

  // 绘制渐变文字
  static drawGradientText(
    ctx: CanvasRenderingContext2D,
    text: string,
    x: number,
    y: number,
    fontSize: number,
    startColor: string,
    endColor: string
  ): void {
    const gradient = ctx.createLinearGradient(x, y, x + text.length * fontSize * 0.6, y)
    gradient.addColorStop(0, startColor)
    gradient.addColorStop(1, endColor)

    ctx.font = `${fontSize}px sans-serif`
    ctx.fillStyle = gradient
    ctx.textAlign = 'center'
    ctx.textBaseline = 'middle'
    ctx.fillText(text, x, y)
  }

  // 绘制树叶装饰图案
  static drawLeafDecoration(
    ctx: CanvasRenderingContext2D,
    x: number,
    y: number,
    size: number,
    color: string,
    rotation: number = 0
  ): void {
    ctx.save()
    ctx.translate(x, y)
    ctx.rotate(rotation)

    // 绘制简单树叶形状
    ctx.beginPath()
    ctx.moveTo(0, -size / 2)
    ctx.bezierCurveTo(size / 2, -size / 2, size / 2, size / 2, 0, size / 2)
    ctx.bezierCurveTo(-size / 2, size / 2, -size / 2, -size / 2, 0, -size / 2)
    ctx.closePath()

    const gradient = ctx.createLinearGradient(-size / 2, 0, size / 2, 0)
    gradient.addColorStop(0, `${color}80`)
    gradient.addColorStop(1, `${color}40`)

    ctx.fillStyle = gradient
    ctx.fill()

    // 绘制叶脉
    ctx.beginPath()
    ctx.moveTo(0, -size / 2)
    ctx.lineTo(0, size / 2)
    ctx.lineWidth = 1
    ctx.strokeStyle = `${color}CC`
    ctx.stroke()

    ctx.restore()
  }

  // 绘制波纹效果
  static drawRipple(
    ctx: CanvasRenderingContext2D,
    x: number,
    y: number,
    maxRadius: number,
    progress: number, // 0-1
    color: string
  ): void {
    const currentRadius = maxRadius * progress
    const alpha = 1 - progress

    ctx.beginPath()
    ctx.arc(x, y, currentRadius, 0, Math.PI * 2)
    ctx.strokeStyle = `${color}${Math.floor(alpha * 255).toString(16).padStart(2, '0')}`
    ctx.lineWidth = 2
    ctx.stroke()
  }

  // 绘制数据条（用于dataPanelComponent）
  static drawDataBar(
    ctx: CanvasRenderingContext2D,
    x: number,
    y: number,
    width: number,
    height: number,
    progress: number, // 0-1
    color: string,
    label: string
  ): void {
    // 绘制背景
    ctx.fillStyle = 'rgba(255, 255, 255, 0.1)'
    ctx.fillRect(x, y, width, height)

    // 绘制进度条
    const progressWidth = width * progress
    const gradient = ctx.createLinearGradient(x, y, x + progressWidth, y)
    gradient.addColorStop(0, `${color}CC`)
    gradient.addColorStop(1, `${color}99`)

    ctx.fillStyle = gradient
    ctx.fillRect(x, y, progressWidth, height)

    // 绘制边框
    ctx.strokeStyle = `${color}66`
    ctx.lineWidth = 1
    ctx.strokeRect(x, y, width, height)

    // 绘制标签
    ctx.font = '12px sans-serif'
    ctx.fillStyle = '#FFFFFF'
    ctx.textAlign = 'left'
    ctx.textBaseline = 'middle'
    ctx.fillText(label, x + 5, y + height / 2)
  }

  // 绘制网格背景
  static drawGridBackground(
    ctx: CanvasRenderingContext2D,
    width: number,
    height: number,
    cellSize: number,
    color: string
  ): void {
    ctx.strokeStyle = `${color}20`
    ctx.lineWidth = 0.5

    // 垂直线
    for (let x = 0; x <= width; x += cellSize) {
      ctx.beginPath()
      ctx.moveTo(x, 0)
      ctx.lineTo(x, height)
      ctx.stroke()
    }

    // 水平线
    for (let y = 0; y <= height; y += cellSize) {
      ctx.beginPath()
      ctx.moveTo(0, y)
      ctx.lineTo(width, y)
      ctx.stroke()
    }
  }
}