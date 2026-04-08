import { preferences } from '@kit.ArkData'
import common from '@ohos.app.ability.common'
import { RedCarEmiPreLogger } from '../Hilog/HilogInfo'

export class ReduceCarEmiPreference {
  private static instance: ReduceCarEmiPreference
  private readonly myPreName: string = 'ReduceCarEmiPre'
  private readonly datePreName: string = 'myDate_carEmi'
  private readonly dataPreName: string = 'myData_carEmi'
  public dataPreferences: preferences.Preferences | null = null
  public acc: string = ''

  public static getInstance(): ReduceCarEmiPreference {
    if (!ReduceCarEmiPreference.instance) {
      ReduceCarEmiPreference.instance = new ReduceCarEmiPreference()
    }
    return ReduceCarEmiPreference.instance
  }

  public getMyPre(context: common.UIAbilityContext) {
    let options: preferences.Options = { name: this.myPreName };
    try {
      this.dataPreferences = preferences.getPreferencesSync(context, options);
    } catch (error) {
      RedCarEmiPreLogger.error('getPreferencesSync error')
    }
  }

  public getTodayTime(): string | null {
    if (!this.dataPreferences) {
      RedCarEmiPreLogger.error('getPreferencesSync error')
      return null
    }

    try {
      let time: string = this.dataPreferences.getSync(this.datePreName + `_${this.acc.trim()}`, '1/1/1999') as string
      RedCarEmiPreLogger.info('getTodayTime: ' + time)
      return time
    } catch (error) {
      RedCarEmiPreLogger.error('getTodayTime error')
      return null
    }
  }

  public setTodayTime(date: string) {
    if (!this.dataPreferences) {
      RedCarEmiPreLogger.error('getPreferencesSync error')
      return
    }

    try {
      this.dataPreferences.putSync(this.datePreName + `_${this.acc.trim()}`, date)
      this.dataPreferences.flush((err: BusinessError) => {
        if (err) {
          RedCarEmiPreLogger.error(`setTodayTime Failed to flush. Code:${err.code}, message:${err.message}`);
        }
      })
    } catch (error) {
      RedCarEmiPreLogger.error('setCurrTime error')
    }
  }

  public setData(data: string) {
    if (!this.dataPreferences) {
      RedCarEmiPreLogger.error('getPreferencesSync error')
      return ''
    }

    try {
      this.dataPreferences.putSync(this.dataPreName + `_${this.acc.trim()}`, data)
      this.dataPreferences.flush((err: BusinessError) => {
        if (err) {
          RedCarEmiPreLogger.error(`setTodayData_HN Failed to flush. Code:${err.code}, message:${err.message}`);
        }
        RedCarEmiPreLogger.info('setTodayData_HN: ' + data)
      })
    } catch (error) {
      RedCarEmiPreLogger.error('setTodayData_HN error')
    }
    return ''
  }

  public getData() {
    if (!this.dataPreferences) {
      RedCarEmiPreLogger.error('getPreferencesSync error')
      return ''
    }

    try {
      let data: string = this.dataPreferences.getSync(this.dataPreName + `_${this.acc.trim()}`, '无') as string
        RedCarEmiPreLogger.info('getTodayData_HN: ' + data)
      return data
    } catch (error) {
      RedCarEmiPreLogger.error('getTodayData_HN error')
      return ''
    }
  }
}