@Observed
export class EnvironTipItemType {
  id: string = ''
  type: number = 0
  title: string = ''
  date: string = ''
  category: string = ''
  author_name: string = ''
  url: string = ''
  thumbnail_pic_s?: string = ''
  thumbnail_pic_s02?: string = ''
  thumbnail_pic_s03?: string = ''
  is_content: string = ''

  constructor(id: string, type: number) {
    this.id = id
    this.type = type
  }
}