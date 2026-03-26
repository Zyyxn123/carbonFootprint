import {
  ApplianceItemDataType,
  FoodItemDataType,
  TransItemDataType,
} from "@ohos/utils";
import { ReduceEmiModel } from "../Model/ReduceEmiModel";

// 碳排放详情接口：定义交通、家电、饮食、总碳排放的返回结构
export interface EmissionDetail {
  trans: number;      // 交通碳排放
  appliance: number;  // 家电碳排放
  food: number;       // 饮食碳排放
  total: number;      // 总碳排放
}

/**
 * 碳排放计算 视图模型（ViewModel）
 * 负责：日期处理、时间范围判断、各类碳排放统计计算
 * 对外提供：今日/自定义天数 的 总碳排/分项碳排 接口
 */
export class ReduceEmiViewModel {
  // 一天的总毫秒数：24小时 * 60分 * 60秒 * 1000毫秒
  private readonly ONE_DAY_MS: number = 24 * 60 * 60 * 1000;

  /**
   * 解析日期字符串 "月/日/年" 格式 → 标准 Date 对象
   * @param time_token 日期字符串，例如 "3/25/2026"
   * @returns 解析后的 Date 对象
   */
  private parseTimeToken(time_token: string): Date {
    if (!time_token) {
      return new Date(0); // 空值返回 1970-01-01
    }
    const dateParts: number[] = time_token.split('/').map(Number);
    const month: number = dateParts[0];
    const day: number = dateParts[1];
    const year: number = dateParts[2];
    return new Date(year, month - 1, day); // JS月份从0开始，需-1
  }

  /**
   * 判断某个日期 是否在【指定天数范围内】
   * @param itemDate 要判断的日期
   * @param days 往前推多少天（如7天、30天）
   * @returns 在范围内返回 true，否则 false
   */
  private isWithinDays(itemDate: Date, days: number): boolean {
    const now: Date = new Date();
    const todayStart: Date = new Date(now.getFullYear(), now.getMonth(), now.getDate()); // 今天 00:00:00
    const startDate: Date = new Date(todayStart.getTime() - days * this.ONE_DAY_MS); // 范围起始日期
    return itemDate >= startDate && itemDate <= todayStart;
  }

  /**
   * 判断某个日期 是否为【今天】
   * @param itemDate 要判断的日期
   * @returns 是今天返回 true，否则 false
   */
  private isToday(itemDate: Date): boolean {
    const now: Date = new Date();
    const sameYear: boolean = itemDate.getFullYear() === now.getFullYear();
    const sameMonth: boolean = itemDate.getMonth() === now.getMonth();
    const sameDay: boolean = itemDate.getDate() === now.getDate();
    return sameYear && sameMonth && sameDay;
  }

  // ====================== 1. 自定义天数 总碳排放 ======================
  /**
   * 计算【自定义天数内】的 总碳排放量（交通+家电+饮食）
   * @param acc 用户账号
   * @param days 统计天数
   * @returns 总碳排放（保留2位小数）
   */
  public async getCustomDaysTotalEmission(acc: string, days: number): Promise<number> {
    // 从Model层获取三类原始数据
    const transResult: TransItemDataType[] = await ReduceEmiModel.getTransItemData(acc);
    const appResult: ApplianceItemDataType[] = await ReduceEmiModel.getAppsItemData(acc);
    const foodResult: FoodItemDataType[] = await ReduceEmiModel.getFoodItemData(acc);

    let total: number = 0;

    // 统计交通类在范围内的碳排放
    for (const item of transResult) {
      const date: Date = this.parseTimeToken(item.time_token);
      if (this.isWithinDays(date, days)) {
        total += item.carbon_emission;
      }
    }

    // 统计家电类在范围内的碳排放
    for (const item of appResult) {
      const date: Date = this.parseTimeToken(item.time_token);
      if (this.isWithinDays(date, days)) {
        total += item.carbon_emission;
      }
    }

    // 统计饮食类在范围内的碳排放
    for (const item of foodResult) {
      const date: Date = this.parseTimeToken(item.time_token);
      if (this.isWithinDays(date, days)) {
        total += item.carbon_emission;
      }
    }

    return Number(total.toFixed(2));
  }

  // ====================== 2. 今日 总碳排放 ======================
  /**
   * 计算【今天】的 总碳排放量（交通+家电+饮食）
   * @param acc 用户账号
   * @returns 今日总碳排放（保留2位小数）
   */
  public async getTodayTotalEmission(acc: string): Promise<number> {
    const trans: number = await this.getTodayTransEmission(acc);
    const appliance: number = await this.getTodayApplianceEmission(acc);
    const food: number = await this.getTodayFoodEmission(acc);
    const total: number = trans + appliance + food;
    return Number(total.toFixed(2));
  }

  // ====================== 3. 今日 分项碳排放（交通/家电/饮食） ======================
  /**
   * 计算【今天】的 交通碳排放量
   */
  public async getTodayTransEmission(acc: string): Promise<number> {
    const items: TransItemDataType[] = await ReduceEmiModel.getTransItemData(acc);
    let total: number = 0;
    for (const item of items) {
      const date: Date = this.parseTimeToken(item.time_token);
      if (this.isToday(date)) {
        total += item.carbon_emission;
      }
    }
    return Number(total.toFixed(2));
  }

  /**
   * 计算【今天】的 家电碳排放量
   */
  public async getTodayApplianceEmission(acc: string): Promise<number> {
    const items: ApplianceItemDataType[] = await ReduceEmiModel.getAppsItemData(acc);
    let total: number = 0;
    for (const item of items) {
      const date: Date = this.parseTimeToken(item.time_token);
      if (this.isToday(date)) {
        total += item.carbon_emission;
      }
    }
    return Number(total.toFixed(2));
  }

  /**
   * 计算【今天】的 饮食碳排放量
   */
  public async getTodayFoodEmission(acc: string): Promise<number> {
    const items: FoodItemDataType[] = await ReduceEmiModel.getFoodItemData(acc);
    let total: number = 0;
    for (const item of items) {
      const date: Date = this.parseTimeToken(item.time_token);
      if (this.isToday(date)) {
        total += item.carbon_emission;
      }
    }
    return Number(total.toFixed(2));
  }

  // ====================== 4. 自定义天数 分项碳排放 ======================
  /**
   * 计算【自定义天数内】的 交通碳排放量
   */
  public async getCustomDaysTransEmission(acc: string, days: number): Promise<number> {
    const items: TransItemDataType[] = await ReduceEmiModel.getTransItemData(acc);
    let total: number = 0;
    for (const item of items) {
      const date: Date = this.parseTimeToken(item.time_token);
      if (this.isWithinDays(date, days)) {
        total += item.carbon_emission;
      }
    }
    return Number(total.toFixed(2));
  }

  /**
   * 计算【自定义天数内】的 家电碳排放量
   */
  public async getCustomDaysApplianceEmission(acc: string, days: number): Promise<number> {
    const items: ApplianceItemDataType[] = await ReduceEmiModel.getAppsItemData(acc);
    let total: number = 0;
    for (const item of items) {
      const date: Date = this.parseTimeToken(item.time_token);
      if (this.isWithinDays(date, days)) {
        total += item.carbon_emission;
      }
    }
    return Number(total.toFixed(2));
  }

  /**
   * 计算【自定义天数内】的 饮食碳排放量
   */
  public async getCustomDaysFoodEmission(acc: string, days: number): Promise<number> {
    const items: FoodItemDataType[] = await ReduceEmiModel.getFoodItemData(acc);
    let total: number = 0;
    for (const item of items) {
      const date: Date = this.parseTimeToken(item.time_token);
      if (this.isWithinDays(date, days)) {
        total += item.carbon_emission;
      }
    }
    return Number(total.toFixed(2));
  }

  // ====================== 5. UI 专用：一次性获取所有分项（方便页面渲染） ======================
  /**
   * 一次性获取【今天】所有碳排放详情（交通、家电、饮食、总计）
   * @param acc 用户账号
   * @returns EmissionDetail 类型对象
   */
  public async getTodayAllEmission(acc: string): Promise<EmissionDetail> {
    const trans: number = await this.getTodayTransEmission(acc);
    const appliance: number = await this.getTodayApplianceEmission(acc);
    const food: number = await this.getTodayFoodEmission(acc);
    const total: number = Number((trans + appliance + food).toFixed(2));

    return { trans, appliance, food, total };
  }

  /**
   * 一次性获取【自定义天数内】所有碳排放详情
   * @param acc 用户账号
   * @param days 统计天数
   * @returns EmissionDetail 类型对象
   */
  public async getCustomDaysAllEmission(acc: string, days: number): Promise<EmissionDetail> {
    const trans: number = await this.getCustomDaysTransEmission(acc, days);
    const appliance: number = await this.getCustomDaysApplianceEmission(acc, days);
    const food: number = await this.getCustomDaysFoodEmission(acc, days);
    const total: number = Number((trans + appliance + food).toFixed(2));

    return { trans, appliance, food, total };
  }
}

// 创建单例，全局复用，避免重复实例化
const reduceEmiVM: ReduceEmiViewModel = new ReduceEmiViewModel()

export default reduceEmiVM