import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import { PreLogger_HN } from '../Hilog/HilogInfo';

export class HealthyNewsPreference {
  private static instance: HealthyNewsPreference
  private readonly myPreName: string = 'HealthyNewsPre'
  private readonly datePreName: string = 'myDate_HN'
  private readonly dataPreName: string = 'myData_HN'
  public dataPreferences: preferences.Preferences | null = null

  public static getInstance(): HealthyNewsPreference {
    if (!HealthyNewsPreference.instance) {
      HealthyNewsPreference.instance = new HealthyNewsPreference()
    }
    return HealthyNewsPreference.instance
  }

  public getMyPre(context: common.UIAbilityContext) {
    let options: preferences.Options = { name: this.myPreName };
    try {
      this.dataPreferences = preferences.getPreferencesSync(context, options);
    } catch (error) {
      PreLogger_HN.error('getPreferencesSync error')
    }
  }

  public getTodayTime() {
    if (!this.dataPreferences) {
      PreLogger_HN.error('getPreferencesSync error')
      return ''
    }

    try {
      if (!this.dataPreferences.hasSync(this.datePreName)) {
        this.setTodayTime()
      }
      let time: string = this.dataPreferences.getSync(this.datePreName, '5/15/2000') as string
      PreLogger_HN.info('getTodayTime: ' + time)
      return time
    } catch (error) {
      PreLogger_HN.error('getTodayTime error')
      return ''
    }
  }

  public getTodayData_HN() {
    if (!this.dataPreferences) {
      PreLogger_HN.error('getPreferencesSync error')
      return ''
    }

    try {
      // if (!this.dataPreferences.hasSync(this.dataPreName)) {
      //   this.setTodayData_HN()
      // }
      let data: string = this.dataPreferences.getSync(this.dataPreName, 'empty') as string
      PreLogger_HN.info('getTodayData_HN: ' + data)
      return data
    } catch (error) {
      PreLogger_HN.error('getTodayData_HN error')
      return ''
    }
  }

  public setTodayTime() {
    if (!this.dataPreferences) {
      PreLogger_HN.error('getPreferencesSync error')
      return ''
    }

    let date: Date = new Date()
    let data: string = date.toLocaleDateString()
    try {
      this.dataPreferences.putSync(this.datePreName, data)
      this.dataPreferences.flush((err: BusinessError) => {
        if (err) {
          PreLogger_HN.error(`setTodayTime Failed to flush. Code:${err.code}, message:${err.message}`);
        }
      })
    } catch (error) {
      PreLogger_HN.error('setCurrTime error')
    }
    return ''
  }

  public setTodayData_HN(data: string) {
    if (!this.dataPreferences) {
      PreLogger_HN.error('getPreferencesSync error')
      return ''
    }

    try {
      this.dataPreferences.putSync(this.dataPreName, data)
      this.dataPreferences.flush((err: BusinessError) => {
        if (err) {
          PreLogger_HN.error(`setTodayData_HN Failed to flush. Code:${err.code}, message:${err.message}`);
        }
        PreLogger_HN.info('setTodayData_HN: ' + data)
      })
    } catch (error) {
      PreLogger_HN.error('setTodayData_HN error')
    }
    return ''
  }
}