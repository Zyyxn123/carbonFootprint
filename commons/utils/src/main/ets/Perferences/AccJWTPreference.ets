import { preferences } from '@kit.ArkData'
import common from '@ohos.app.ability.common'
import { AccJWTPreLogger } from '../Hilog/HilogInfo'

export class AccJWTPreference {
  private static instance: AccJWTPreference
  private readonly myPreName: string = 'AccJWTPre'
  public dataPreferences: preferences.Preferences | null = null

  public static getInstance(): AccJWTPreference {
    if (!AccJWTPreference.instance) {
      AccJWTPreference.instance = new AccJWTPreference()
    }
    return AccJWTPreference.instance
  }

  public getMyPre(context: common.UIAbilityContext) {
    let options: preferences.Options = { name: this.myPreName };
    try {
      this.dataPreferences = preferences.getPreferencesSync(context, options);
    } catch (error) {
      AccJWTPreLogger.error('getPreferencesSync error')
    }
  }

  public setCurrAccJWT(acc: string, JWT: string) {
    if (!this.dataPreferences) {
      AccJWTPreLogger.error('getPreferencesSync error')
      return ''
    }

    try {
      this.dataPreferences.putSync(acc, JWT)
      this.dataPreferences.flush((err: BusinessError) => {
        if (err) {
          AccJWTPreLogger.error(`setCurrAccJWT Failed to flush. Code:${err.code}, message:${err.message}`);
        }
        AccJWTPreLogger.info('setCurrAccJWT flush success: '
          + `acc=${acc}, JWT=${JWT}`)
      })
    } catch (error) {
      AccJWTPreLogger.error('setCurrAccJWT error')
    }
    return ''
  }

  public getCurrAccJWT(acc: string) {
    if (!this.dataPreferences) {
      AccJWTPreLogger.error('getPreferencesSync error')
      return ''
    }

    try {
      let JWT: string = this.dataPreferences.getSync(acc, '') as string
      AccJWTPreLogger.info('getCurrAccJWT: ' + JWT)
      return JWT
    } catch (error) {
      AccJWTPreLogger.error('getCurrAccJWT error')
      return ''
    }
  }
}