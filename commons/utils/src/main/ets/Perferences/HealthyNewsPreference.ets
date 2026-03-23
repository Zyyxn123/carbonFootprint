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
        this.setTodayTime('1/1/1999')
      }
      let time: string = this.dataPreferences.getSync(this.datePreName, '1/1/1999') as string
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
      let data: string = this.dataPreferences.getSync(this.dataPreName, '[{"uniquekey":"health_20260323_001","title":"春季养生：如何科学补充维生素","date":"2026-03-23 08:30:00","category":"养生科普","author_name":"健康养生专家","url":"https://example.com/health/001","thumbnail_pic_s":"https://example.com/images/health_001_s.jpg","thumbnail_pic_s02":"https://example.com/images/health_001_s02.jpg","thumbnail_pic_s03":"https://example.com/images/health_001_s03.jpg","is_content":"1"},{"uniquekey":"health_20260323_002","title":"每天8000步真的健康吗？运动专家给出答案","date":"2026-03-23 09:15:00","category":"运动健康","author_name":"运动医学博士","url":"https://example.com/health/002","thumbnail_pic_s":"https://example.com/images/health_002_s.jpg","is_content":"1"},{"uniquekey":"health_20260323_003","title":"熬夜对心血管的不可逆伤害","date":"2026-03-23 10:20:00","category":"心血管健康","author_name":"心内科主任医师","url":"https://example.com/health/003","thumbnail_pic_s02":"https://example.com/images/health_003_s02.jpg","is_content":"0"},{"uniquekey":"health_20260323_004","title":"膳食纤维摄入不足的5个信号","date":"2026-03-23 14:45:00","category":"营养饮食","author_name":"注册营养师","url":"https://example.com/health/004","is_content":"1"},{"uniquekey":"health_20260323_005","title":"正确的颈椎放松方法，远离办公室职业病","date":"2026-03-23 16:10:00","category":"骨骼健康","author_name":"康复理疗师","url":"https://example.com/health/005","thumbnail_pic_s":"https://example.com/images/health_005_s.jpg","thumbnail_pic_s03":"https://example.com/images/health_005_s03.jpg","is_content":"1"}]') as string
      PreLogger_HN.info('getTodayData_HN: ' + data)
      return data
    } catch (error) {
      PreLogger_HN.error('getTodayData_HN error')
      return ''
    }
  }

  public setTodayTime(date: string) {
    if (!this.dataPreferences) {
      PreLogger_HN.error('getPreferencesSync error')
      return ''
    }

    try {
      this.dataPreferences.putSync(this.datePreName, date)
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