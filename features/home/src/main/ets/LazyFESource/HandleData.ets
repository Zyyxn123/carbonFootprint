import { HealthNewsItem } from '@ohos/utils';
import { EnvironTipItemType } from '../Type/EnvironTipItemType';
import { JSON } from '@kit.ArkTS';

export interface type {
  dataList: HealthNewsItem[]
}

/**
 * 处理健康资讯数据，转换为环境提示列表项数据
 * @param array 原始健康资讯数组
 * @returns 处理后的EnvironTipItemType数组
 */
export function getHandledItemData(array: string): EnvironTipItemType[] {
  if (!array || array.length === 0) {
    return []
  }
  console.log('getHandledItemData1: ', array)
  let data = JSON.parse(array) as type
  const result: EnvironTipItemType[] = []
  const length: number = data.dataList.length
  console.log('getHandledItemData2: ', length)
  console.log('getHandledItemData2: ', data.dataList[0].title)

  for (let index = 0; index < length; index++) {
      const picCount = countValidPics(data.dataList[index])
      const itemType = getTypeByPicCount(picCount)
      const handledItem = new EnvironTipItemType(data.dataList[index].uniquekey || `item_${index}`, itemType)

    handledItem.title = data.dataList[index].title || ''
    handledItem.date = data.dataList[index].date/*formatDate(dataList[index].date) || '' // 可选：格式化时间显示*/
    handledItem.category = data.dataList[index].category || ''
    handledItem.author_name = data.dataList[index].author_name || ''
    handledItem.url = data.dataList[index].url || ''
    handledItem.thumbnail_pic_s = data.dataList[index].thumbnail_pic_s || ''
    handledItem.thumbnail_pic_s02 = data.dataList[index].thumbnail_pic_s02 || ''
    handledItem.thumbnail_pic_s03 = data.dataList[index].thumbnail_pic_s03 || ''
    handledItem.is_content = data.dataList[index].is_content || ''

    result.push(handledItem)
    console.log('getHandledItemData3: ', JSON.stringify(handledItem))
  }

  // dataList.forEach((item, index) => {
  //   const picCount = countValidPics(item)
  //   const itemType = getTypeByPicCount(picCount)
  //   const handledItem = new EnvironTipItemType(item.uniquekey || `item_${index}`, itemType)
  //
  //   handledItem.title = item.title || ''
  //   handledItem.date = formatDate(item.date) || '' // 可选：格式化时间显示
  //   handledItem.category = item.category || ''
  //   handledItem.author_name = item.author_name || ''
  //   handledItem.url = item.url || ''
  //   handledItem.thumbnail_pic_s = item.thumbnail_pic_s || ''
  //   handledItem.thumbnail_pic_s02 = item.thumbnail_pic_s02 || ''
  //   handledItem.thumbnail_pic_s03 = item.thumbnail_pic_s03 || ''
  //   handledItem.is_content = item.is_content || ''
  //
  //   result.push(handledItem)
  //   console.log('getHandledItemData2: ', handledItem)
  // })
  return result
}

/**
 * 统计有效图片数量（非空字符串的图片链接）
 * @param item 单条健康资讯
 * @returns 有效图片数（0/1/2/3）
 */
function countValidPics(item: HealthNewsItem): number {
  let count = 0
  if (item.thumbnail_pic_s && item.thumbnail_pic_s.trim() !== '') {
    count++
  }
  if (item.thumbnail_pic_s02 && item.thumbnail_pic_s02.trim() !== '') {
    count++
  }
  if (item.thumbnail_pic_s03 && item.thumbnail_pic_s03.trim() !== '') {
    count++
  }
  return count
}

/**
 * 根据图片数量确定type值
 * - 1张图 → type=1
 * - 2张图 → type=2
 * - 3张图 → type=2
 * - 0张图 → 默认type=0（可根据业务调整）
 * @param count 图片数量
 * @returns type值
 */
function getTypeByPicCount(count: number): number {
  switch (count) {
    case 0:
      return 0
    case 1:
      return 1
    default:
      return 2
  }
}

/**
 * 可选：格式化日期显示（如"2026-03-12 10:27:00" → "10:27 03-12"）
 * @param dateStr 原始日期字符串
 * @returns 格式化后的日期
 */
function formatDate(dateStr: string): string {
  if (!dateStr) {
    return ''
  }

  // 移除元组解构，改用传统split+索引取值
  const dateTimeArray = dateStr.split(' ')
  const datePart = dateTimeArray[0] // 日期部分（2026-03-12）
  const timePart = dateTimeArray[1] // 时间部分（10:27:00）

  if (!datePart || !timePart) {
    return dateStr
  }

  // 处理日期部分
  const dateArray = datePart.split('-')
  const year = dateArray[0]
  const month = dateArray[1]
  const day = dateArray[2]

  // 处理时间部分
  const timeArray = timePart.split(':')
  const hour = timeArray[0]
  const minute = timeArray[1]

  return hour + ':' + minute + ' ' + month + '-' + day
}

/**
 * 保留原有的数组乱序函数（移除元组交换写法）
 */
function shuffleArray<T>(array: T[]): T[] {
  const shuffled = [...array];
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    // 移除元组交换，改用临时变量
    const temp = shuffled[i];
    shuffled[i] = shuffled[j];
    shuffled[j] = temp;
  }
  return shuffled;
}