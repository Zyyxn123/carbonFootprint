/**
 * 动画工具类
 * 提供常用的动画配置和效果
 */

// 👉 第一步：定义动画配置接口（修复关键）
export interface AnimationConfig {
  duration: number;
  curve: Curve;
  delay?: number;
  iterations?: number;
  onFinish?: () => void;
}

export class AnimationUtils {
  // 入场动画配置
  static slideInFromTop(delay: number = 0): AnimationConfig {
    return {
      duration: 500,
      curve: Curve.EaseOut,
      delay: delay,
      onFinish: () => {
        console.log('Slide in from top animation finished')
      }
    }
  }

  static slideInFromBottom(delay: number = 0): AnimationConfig {
    return {
      duration: 500,
      curve: Curve.EaseOut,
      delay: delay,
      onFinish: () => {
        console.log('Slide in from bottom animation finished')
      }
    }
  }

  static slideInFromLeft(delay: number = 0): AnimationConfig {
    return {
      duration: 500,
      curve: Curve.EaseOut,
      delay: delay,
      onFinish: () => {
        console.log('Slide in from left animation finished')
      }
    }
  }

  static slideInFromRight(delay: number = 0): AnimationConfig {
    return {
      duration: 500,
      curve: Curve.EaseOut,
      delay: delay,
      onFinish: () => {
        console.log('Slide in from right animation finished')
      }
    }
  }

  static fadeIn(delay: number = 0): AnimationConfig {
    return {
      duration: 600,
      curve: Curve.EaseInOut,
      delay: delay,
      onFinish: () => {
        console.log('Fade in animation finished')
      }
    }
  }

  static scaleIn(delay: number = 0): AnimationConfig {
    return {
      duration: 500,
      curve: Curve.EaseInOut,
      delay: delay,
      onFinish: () => {
        console.log('Scale in animation finished')
      }
    }
  }

  // 悬停动画配置
  static hoverScale(): AnimationConfig {
    return {
      duration: 200,
      curve: Curve.EaseInOut
    }
  }

  static hoverShadow(): AnimationConfig {
    return {
      duration: 200,
      curve: Curve.EaseInOut
    }
  }

  // 点击动画配置
  static clickScale(): AnimationConfig {
    return {
      duration: 150,
      curve: Curve.EaseOut
    }
  }

  static rippleEffect(): AnimationConfig {
    return {
      duration: 400,
      curve: Curve.EaseOut
    }
  }

  // 状态动画配置
  static loadingSpin(): AnimationConfig {
    return {
      duration: 1000,
      curve: Curve.Linear,
      iterations: -1 // 无限循环
    }
  }

  static successCheck(): AnimationConfig {
    return {
      duration: 500,
      curve: Curve.EaseOut
    }
  }

  static errorShake(): AnimationConfig {
    return {
      duration: 300,
      curve: Curve.EaseInOut,
      iterations: 2
    }
  }

  // 组合动画
  static cardEnterStagger(index: number): AnimationConfig {
    return {
      duration: 500,
      curve: Curve.EaseInOut,
      delay: index * 100 // 交错延迟
    }
  }

  // 数值动画（用于数字滚动）
  static numberRolling(duration: number = 1000): AnimationConfig {
    return {
      duration: duration,
      curve: Curve.EaseOut
    }
  }

  // 颜色过渡动画
  static colorTransition(duration: number = 300): AnimationConfig {
    return {
      duration: duration,
      curve: Curve.EaseInOut
    }
  }

  // 旋转动画
  static rotateAnimation(duration: number = 500, iterations: number = 1): AnimationConfig {
    return {
      duration: duration,
      curve: Curve.Linear,
      iterations: iterations
    }
  }

  // 脉动动画
  static pulseAnimation(): AnimationConfig {
    return {
      duration: 1000,
      curve: Curve.EaseInOut,
      iterations: -1
    }
  }

  // 获取动画配置的简化方法
  static getEnterAnimation(type: string, delay: number = 0): AnimationConfig {
    switch (type) {
      case 'top':
        return AnimationUtils.slideInFromTop(delay)
      case 'bottom':
        return AnimationUtils.slideInFromBottom(delay)
      case 'left':
        return AnimationUtils.slideInFromLeft(delay)
      case 'right':
        return AnimationUtils.slideInFromRight(delay)
      case 'fade':
        return AnimationUtils.fadeIn(delay)
      case 'scale':
        return AnimationUtils.scaleIn(delay)
      default:
        return AnimationUtils.fadeIn(delay)
    }
  }
}