export interface redEmiRecType {
  id: number
  recMeasure: string
  emiRedEffect: string
  adaptOffer: string
}

class LittleTipsModel {
  private transportScene: redEmiRecType[] = [
    { id: 1, recMeasure: "短途3km内优先步行或骑行，中长途选公交地铁，自驾拼车并减少急加速急刹车", emiRedEffect: "践行后每月可减少碳排放12.5kg，预计节省出行成本180元", adaptOffer: "结合您日常通勤里程15km，推荐每周2-3天公共交通出行" },
    { id: 2, recMeasure: "上下班错峰出行避开拥堵路段，优先选择共享单车替代短途网约车，减少怠速排放", emiRedEffect: "每月可减少碳排放9.8kg，同时降低通勤时间约15%", adaptOffer: "根据您早高峰通勤习惯，建议提前30分钟出发选择骑行" },
    { id: 3, recMeasure: "跨城出行优先选择高铁或长途大巴，减少自驾燃油消耗，降低尾气排放", emiRedEffect: "单次跨城出行可减少碳排放约25kg，节省交通费用约30%", adaptOffer: "结合您每月2次跨城需求，推荐优先选择高铁出行" },
    { id: 4, recMeasure: "日常购物选择步行或骑行前往社区超市，避免短途自驾，减少车辆启动排放", emiRedEffect: "每周3次步行购物可减少碳排放2.1kg，同时增加日常运动量", adaptOffer: "针对您家周边1km内商超，建议步行或骑行前往" },
    { id: 5, recMeasure: "通勤时选择拼车或顺风车，与同事共享车辆资源，减少单人自驾的碳排放", emiRedEffect: "拼车出行可减少约40%的人均碳排放，分摊油费降低出行成本", adaptOffer: "根据您通勤路线，推荐在平台匹配同方向同事拼车" },
    { id: 6, recMeasure: "周末短途出游选择公共交通或共享单车，避免自驾拥堵，减少尾气排放", emiRedEffect: "单次出游可减少碳排放约8kg，同时享受绿色出行体验", adaptOffer: "结合您周末出游习惯，推荐选择近郊公交或骑行路线" },
    { id: 7, recMeasure: "接送孩子上下学选择步行或骑行，避开早高峰拥堵，减少车辆怠速产生的排放", emiRedEffect: "每日步行接送可减少碳排放1.2kg，同时增加亲子互动时间", adaptOffer: "针对您家到学校1.2km距离，建议步行或骑行接送" },
    { id: 8, recMeasure: "日常出行提前规划路线，避开拥堵路段，减少车辆怠速时间，降低燃油消耗", emiRedEffect: "规划路线可减少约15%的碳排放，节省通勤时间约20%", adaptOffer: "使用导航软件提前规划最优路线，避开早晚高峰路段" },
    { id: 9, recMeasure: "短途就医选择步行或骑行，避免自驾找车位浪费时间，减少车辆启动排放", emiRedEffect: "单次就医出行可减少碳排放1.5kg，同时节省停车费用", adaptOffer: "根据您家到社区医院0.8km距离，推荐步行前往" },
    { id: 10, recMeasure: "上下班选择地铁或公交，减少单人自驾，降低城市道路拥堵和尾气排放", emiRedEffect: "每日公共交通出行可减少碳排放3.2kg，节省油费约150元/月", adaptOffer: "结合您通勤12km路程，推荐选择地铁+步行的组合方式" },
    { id: 11, recMeasure: "周末逛公园选择共享单车或步行，避免自驾停车难，减少车辆怠速排放", emiRedEffect: "单次公园出行可减少碳排放2.3kg，同时增加户外活动时间", adaptOffer: "针对您家到公园2km距离，建议骑行或步行前往" },
    { id: 12, recMeasure: "跨区办事优先选择地铁或公交，避免自驾拥堵，减少燃油消耗和尾气排放", emiRedEffect: "单次跨区办事可减少碳排放4.5kg，节省交通费用约25%", adaptOffer: "根据您办事地点，推荐选择直达地铁线路出行" },
    { id: 13, recMeasure: "日常取快递选择步行或骑行，避免短途自驾，减少车辆启动产生的碳排放", emiRedEffect: "每日取件步行可减少碳排放0.8kg，同时增加日常步数", adaptOffer: "针对您家到快递点0.5km距离，建议步行取件" },
    { id: 14, recMeasure: "通勤时选择电动自行车替代燃油摩托车，减少尾气排放，降低噪音污染", emiRedEffect: "电动自行车出行可减少约90%的碳排放，节省能源费用约80%", adaptOffer: "结合您通勤8km路程，推荐选择合规电动自行车出行" },
    { id: 15, recMeasure: "节假日长途出行优先选择高铁或动车，减少自驾燃油消耗，降低碳排放总量", emiRedEffect: "单次长途出行可减少碳排放约50kg，同时节省驾驶疲劳", adaptOffer: "根据您节假日返乡需求，推荐提前预订高铁车票" },
    { id: 16, recMeasure: "日常买菜选择步行或骑行前往菜市场，避免短途自驾，减少车辆启动排放", emiRedEffect: "每日步行买菜可减少碳排放1.1kg，同时增加日常运动量", adaptOffer: "针对您家到菜市场1km距离，建议步行或骑行前往" },
    { id: 17, recMeasure: "上下班选择拼车或顺风车，与邻居共享车辆资源，减少单人自驾的碳排放", emiRedEffect: "拼车出行可减少约35%的人均碳排放，分摊油费降低出行成本", adaptOffer: "根据您通勤路线，推荐在平台匹配同小区邻居拼车" },
    { id: 18, recMeasure: "周末健身选择步行或骑行前往健身房，避免自驾，减少车辆怠速产生的排放", emiRedEffect: "单次健身出行可减少碳排放1.8kg，同时作为热身运动", adaptOffer: "针对您家到健身房1.5km距离，建议骑行或步行前往" },
    { id: 19, recMeasure: "日常通勤选择公交+步行的组合方式，减少单人自驾，降低尾气排放", emiRedEffect: "每日组合出行可减少碳排放2.8kg，节省油费约120元/月", adaptOffer: "结合您通勤10km路程，推荐选择直达公交+步行" },
    { id: 20, recMeasure: "跨城出差优先选择高铁或飞机，减少自驾长途行驶，降低燃油消耗和碳排放", emiRedEffect: "单次出差可减少碳排放约30kg，同时节省时间提高效率", adaptOffer: "根据您出差目的地，推荐选择最快高铁或航班出行" },
    { id: 21, recMeasure: "日常接送老人选择步行或骑行，避免自驾，减少车辆启动和怠速排放", emiRedEffect: "每日接送步行可减少碳排放1.3kg，同时陪伴老人散步", adaptOffer: "针对您家到老人住所0.9km距离，建议步行接送" },
    { id: 22, recMeasure: "周末购物选择公共交通或共享单车，避免自驾拥堵，减少尾气排放", emiRedEffect: "单次购物出行可减少碳排放3.5kg，同时节省停车费用", adaptOffer: "结合您购物商场位置，推荐选择地铁或共享单车前往" },
    { id: 23, recMeasure: "日常通勤选择电动滑板车或平衡车，替代短途自驾，减少碳排放和噪音污染", emiRedEffect: "电动滑板车出行可减少约85%的碳排放，节省能源费用约75%", adaptOffer: "针对您通勤5km路程，推荐选择合规电动滑板车出行" },
    { id: 24, recMeasure: "跨区就医优先选择地铁或公交，避免自驾找车位，减少车辆怠速排放", emiRedEffect: "单次就医出行可减少碳排放5.2kg，同时节省停车时间", adaptOffer: "根据您就医医院位置，推荐选择直达地铁线路出行" },
    { id: 25, recMeasure: "日常取文件选择步行或骑行，避免短途自驾，减少车辆启动产生的碳排放", emiRedEffect: "每日取件步行可减少碳排放0.7kg，同时增加日常活动量", adaptOffer: "针对您家到单位0.6km距离，建议步行取件" },
    { id: 26, recMeasure: "上下班选择拼车或顺风车，与同事共享车辆，减少单人自驾的碳排放和拥堵", emiRedEffect: "拼车出行可减少约40%的人均碳排放，分摊油费降低出行成本", adaptOffer: "根据您通勤时间，推荐在平台匹配同时间出发同事拼车" },
    { id: 27, recMeasure: "周末逛书店选择步行或骑行，避免自驾，减少车辆怠速产生的排放", emiRedEffect: "单次书店出行可减少碳排放1.6kg，同时享受慢生活节奏", adaptOffer: "针对您家到书店1.3km距离，建议骑行或步行前往" },
    { id: 28, recMeasure: "日常通勤选择公交+共享单车的组合方式，减少单人自驾，降低尾气排放", emiRedEffect: "每日组合出行可减少碳排放3.1kg，节省油费约130元/月", adaptOffer: "结合您通勤11km路程，推荐选择公交+共享单车出行" },
    { id: 29, recMeasure: "跨城探亲优先选择高铁或长途大巴，减少自驾燃油消耗，降低碳排放总量", emiRedEffect: "单次探亲出行可减少碳排放约40kg，同时避免长途驾驶疲劳", adaptOffer: "根据您探亲目的地，推荐提前预订高铁或大巴车票" },
    { id: 30, recMeasure: "日常遛狗选择步行，避免自驾，减少车辆启动和怠速产生的碳排放", emiRedEffect: "每日遛狗步行可减少碳排放0.9kg，同时陪伴宠物运动", adaptOffer: "针对您家周边遛狗区域，建议步行前往避免自驾" },
    { id: 31, recMeasure: "上下班选择地铁+共享单车的组合方式，减少单人自驾，降低城市尾气排放", emiRedEffect: "每日组合出行可减少碳排放3.4kg，节省油费约140元/月", adaptOffer: "结合您通勤13km路程，推荐选择地铁+共享单车出行" },
    { id: 32, recMeasure: "周末露营选择公共交通或拼车，避免单人自驾，减少燃油消耗和碳排放", emiRedEffect: "单次露营出行可减少碳排放约10kg，同时与朋友共享出行乐趣", adaptOffer: "根据您露营地点，推荐选择拼车或近郊公交出行" },
    { id: 33, recMeasure: "日常取外卖选择步行或骑行，避免短途自驾，减少车辆启动产生的碳排放", emiRedEffect: "每日取餐步行可减少碳排放0.6kg，同时增加日常步数", adaptOffer: "针对您家到外卖点0.4km距离，建议步行取餐" },
    { id: 34, recMeasure: "跨区办事优先选择拼车或顺风车，减少单人自驾，降低燃油消耗和尾气排放", emiRedEffect: "拼车出行可减少约30%的人均碳排放，分摊油费降低出行成本", adaptOffer: "根据您办事时间，推荐在平台匹配同方向人员拼车" },
    { id: 35, recMeasure: "日常通勤选择步行或骑行，替代短途自驾，减少碳排放和城市拥堵", emiRedEffect: "每日步行通勤可减少碳排放2.5kg，同时提升身体素质", adaptOffer: "针对您通勤2km路程，推荐全程步行或骑行通勤" },
    { id: 36, recMeasure: "周末看电影选择公共交通或共享单车，避免自驾找车位，减少车辆怠速排放", emiRedEffect: "单次观影出行可减少碳排放2.7kg，同时节省停车费用", adaptOffer: "结合您影院位置，推荐选择地铁或共享单车前往" },
    { id: 37, recMeasure: "日常接送孩子选择拼车或顺风车，与其他家长共享车辆，减少单人自驾排放", emiRedEffect: "拼车接送可减少约45%的人均碳排放，分摊油费降低出行成本", adaptOffer: "根据您孩子学校位置，推荐在家长群匹配拼车伙伴" },
    { id: 38, recMeasure: "跨城旅游优先选择高铁或动车，减少自驾燃油消耗，降低碳排放总量", emiRedEffect: "单次旅游出行可减少碳排放约60kg，同时欣赏沿途风景", adaptOffer: "根据您旅游目的地，推荐选择高铁或动车作为交通方式" },
    { id: 39, recMeasure: "日常买菜选择社区团购+步行自提，避免自驾购物，减少车辆启动排放", emiRedEffect: "每周2次自提可减少碳排放1.9kg，同时节省购物时间", adaptOffer: "针对您家周边自提点，推荐选择步行自提替代自驾购物" },
    { id: 40, recMeasure: "上下班选择电动公交车或地铁，零尾气排放，降低城市空气污染和碳排放", emiRedEffect: "每日公共交通出行可减少碳排放3.8kg，节省油费约160元/月", adaptOffer: "结合您通勤14km路程，推荐选择直达电动公交车出行" }
  ]
  private applianceScene: redEmiRecType[] = [
    { id: 1, recMeasure: "养成随手断电习惯，杜绝电器待机，空调夏季设26℃、冬季设20℃，更换节能灯具", emiRedEffect: "每月可减少用电35度，降低碳排放8.3kg，节省电费21元", adaptOffer: "针对您夜间电器待机8h/天，断电后日均减排0.3kg CO₂e" },
    { id: 2, recMeasure: "使用完电器后及时拔掉插头，避免待机耗电，空调温度设定合理，避免频繁开关", emiRedEffect: "每月可减少用电28度，降低碳排放6.7kg，节省电费17元", adaptOffer: "根据您空调使用习惯，推荐设定温度后避免频繁调节" },
    { id: 3, recMeasure: "更换家中白炽灯为LED节能灯，使用智能插座控制电器，错峰用电降低能耗", emiRedEffect: "每月可减少用电22度，降低碳排放5.2kg，节省电费13元", adaptOffer: "针对您家照明需求，推荐全部更换为LED节能灯具" },
    { id: 4, recMeasure: "冰箱避免频繁开门，食物冷却后再放入，定期清理冷凝器灰尘，提高制冷效率", emiRedEffect: "每月可减少用电18度，降低碳排放4.3kg，节省电费11元", adaptOffer: "根据您冰箱使用频率，推荐减少开门次数和时长" },
    { id: 5, recMeasure: "洗衣机选择冷水洗涤模式，满载运行，避免半桶洗衣浪费水电，延长机器寿命", emiRedEffect: "每月可减少用电15度，降低碳排放3.6kg，节省水费8元", adaptOffer: "结合您洗衣习惯，推荐积攒满桶后再启动洗衣机" },
    { id: 6, recMeasure: "电视、电脑不用时彻底关机，避免待机耗电，使用节能模式降低屏幕亮度", emiRedEffect: "每月可减少用电12度，降低碳排放2.9kg，节省电费7元", adaptOffer: "针对您夜间看电视习惯，推荐看完后彻底关机断电" },
    { id: 7, recMeasure: "电热水器使用后及时关闭，避免长时间保温耗电，选择即热式或分时供电", emiRedEffect: "每月可减少用电30度，降低碳排放7.1kg，节省电费18元", adaptOffer: "根据您洗澡频率，推荐使用后关闭电热水器电源" },
    { id: 8, recMeasure: "微波炉、烤箱使用时避免空载，选择合适功率，减少加热时间，降低能耗", emiRedEffect: "每月可减少用电10度，降低碳排放2.4kg，节省电费6元", adaptOffer: "结合您烹饪习惯，推荐选择合适功率和时间加热" },
    { id: 9, recMeasure: "吸尘器、扫地机器人选择节能模式，避免长时间运行，定期清理滤网提高效率", emiRedEffect: "每月可减少用电8度，降低碳排放1.9kg，节省电费5元", adaptOffer: "针对您清洁需求，推荐选择节能模式并定期清理滤网" },
    { id: 10, recMeasure: "空调滤网定期清洗，提高制冷/制热效率，减少能耗，延长空调使用寿命", emiRedEffect: "每月可减少用电20度，降低碳排放4.7kg，节省电费12元", adaptOffer: "根据您空调使用时长，推荐每1-2个月清洗一次滤网" },
    { id: 11, recMeasure: "路由器、机顶盒不用时关闭电源，避免24小时待机耗电，减少不必要能耗", emiRedEffect: "每月可减少用电9度，降低碳排放2.1kg，节省电费5元", adaptOffer: "针对您夜间不用网习惯，推荐睡前关闭路由器和机顶盒" },
    { id: 12, recMeasure: "电饭煲选择保温时间不超过2小时，避免长时间保温浪费电能，使用后及时断电", emiRedEffect: "每月可减少用电7度，降低碳排放1.7kg，节省电费4元", adaptOffer: "结合您用餐时间，推荐饭熟后及时断电避免长时间保温" },
    { id: 13, recMeasure: "电熨斗、电吹风使用后及时拔掉插头，避免待机耗电，选择合适功率使用", emiRedEffect: "每月可减少用电6度，降低碳排放1.4kg，节省电费3元", adaptOffer: "针对您使用频率，推荐使用后立即拔掉电源插头" },
    { id: 14, recMeasure: "加湿器、空气净化器不用时关闭，避免24小时运行，根据空气质量调节档位", emiRedEffect: "每月可减少用电11度，降低碳排放2.6kg，节省电费6元", adaptOffer: "根据您室内环境，推荐按需开启避免长时间运行" },
    { id: 15, recMeasure: "冰箱放置在阴凉通风处，远离热源，避免阳光直射，提高制冷效率降低能耗", emiRedEffect: "每月可减少用电16度，降低碳排放3.8kg，节省电费9元", adaptOffer: "针对您家冰箱位置，推荐调整至阴凉通风处" },
    { id: 16, recMeasure: "洗衣机选择快洗模式，减少洗涤时间，降低水电消耗，提高使用效率", emiRedEffect: "每月可减少用电13度，降低碳排放3.1kg，节省水费7元", adaptOffer: "结合您衣物脏污程度，推荐选择快洗模式清洁" },
    { id: 17, recMeasure: "电脑设置自动休眠模式，长时间不用时自动关机，减少待机耗电，节约能源", emiRedEffect: "每月可减少用电14度，降低碳排放3.3kg，节省电费8元", adaptOffer: "根据您电脑使用习惯，推荐设置10分钟无操作自动休眠" },
    { id: 18, recMeasure: "空调避免直吹人体，使用挡风板，提高制冷效率，减少不必要能耗", emiRedEffect: "每月可减少用电19度，降低碳排放4.5kg，节省电费11元", adaptOffer: "针对您空调安装位置，推荐加装挡风板优化气流" },
    { id: 19, recMeasure: "电热水壶只烧需要的水量，避免满壶烧水浪费电能，使用后及时断电", emiRedEffect: "每月可减少用电5度，降低碳排放1.2kg，节省电费3元", adaptOffer: "结合您饮水需求，推荐只烧当日所需水量" },
    { id: 20, recMeasure: "电视选择节能模式，降低屏幕亮度和音量，减少能耗，延长电视使用寿命", emiRedEffect: "每月可减少用电10度，降低碳排放2.4kg，节省电费6元", adaptOffer: "根据您观看环境，推荐调节至合适亮度和音量" },
    { id: 21, recMeasure: "微波炉使用时覆盖保鲜膜，减少水分流失，缩短加热时间，降低能耗", emiRedEffect: "每月可减少用电8度，降低碳排放1.9kg，节省电费5元", adaptOffer: "结合您加热食物习惯，推荐覆盖保鲜膜缩短加热时间" },
    { id: 22, recMeasure: "吸尘器选择低功率模式，清洁地面时避免重复清扫，提高效率降低能耗", emiRedEffect: "每月可减少用电7度，降低碳排放1.7kg，节省电费4元", adaptOffer: "针对您清洁区域，推荐选择低功率模式一次性清扫" },
    { id: 23, recMeasure: "电热水器设定合适水温，避免过高温度浪费电能，使用后及时关闭", emiRedEffect: "每月可减少用电25度，降低碳排放5.9kg，节省电费15元", adaptOffer: "根据您洗澡需求，推荐设定水温40℃左右" },
    { id: 24, recMeasure: "路由器放置在通风处，避免信号干扰，减少功率消耗，延长使用寿命", emiRedEffect: "每月可减少用电8度，降低碳排放1.9kg，节省电费5元", adaptOffer: "针对您家网络布局，推荐放置在客厅中央通风位置" },
    { id: 25, recMeasure: "电饭煲选择合适容量，避免大电饭煲煮少量饭，浪费电能提高效率", emiRedEffect: "每月可减少用电6度，降低碳排放1.4kg，节省电费3元", adaptOffer: "结合您家庭人口，推荐选择匹配容量的电饭煲" },
    { id: 26, recMeasure: "电吹风选择低温模式，减少热风功率，降低能耗，同时保护头发健康", emiRedEffect: "每月可减少用电5度，降低碳排放1.2kg，节省电费3元", adaptOffer: "根据您头发长度，推荐选择低温模式吹干头发" },
    { id: 27, recMeasure: "空气净化器根据空气质量自动调节档位，避免高档位持续运行，降低能耗", emiRedEffect: "每月可减少用电12度，降低碳排放2.9kg，节省电费7元", adaptOffer: "结合您室内PM2.5值，推荐开启自动模式调节" },
    { id: 28, recMeasure: "冰箱定期除霜，避免霜层过厚影响制冷效率，提高制冷效果降低能耗", emiRedEffect: "每月可减少用电17度，降低碳排放4.0kg，节省电费10元", adaptOffer: "根据您冰箱结霜情况，推荐每季度除霜一次" },
    { id: 29, recMeasure: "洗衣机选择脱水模式，减少晾晒时间，降低水电消耗，提高使用效率", emiRedEffect: "每月可减少用电11度，降低碳排放2.6kg，节省水费6元", adaptOffer: "结合您衣物材质，推荐选择合适脱水转速" },
    { id: 30, recMeasure: "电脑关闭不必要的后台程序，减少CPU负载，降低能耗延长电池寿命", emiRedEffect: "每月可减少用电13度，降低碳排放3.1kg，节省电费8元", adaptOffer: "根据您电脑使用情况，推荐定期清理后台程序" },
    { id: 31, recMeasure: "空调使用时关闭门窗，避免冷热空气流失，提高制冷/制热效率，减少能耗", emiRedEffect: "每月可减少用电21度，降低碳排放5.0kg，节省电费12元", adaptOffer: "针对您空调使用场景，推荐开启时关闭门窗" },
    { id: 32, recMeasure: "电热水壶使用不锈钢材质，提高导热效率，减少加热时间，降低能耗", emiRedEffect: "每月可减少用电4度，降低碳排放0.9kg，节省电费2元", adaptOffer: "结合您烧水需求，推荐选择不锈钢电热水壶" },
    { id: 33, recMeasure: "电视避免长时间待机，使用后彻底关机，减少不必要的电能消耗", emiRedEffect: "每月可减少用电9度，降低碳排放2.1kg，节省电费5元", adaptOffer: "针对您看电视习惯，推荐使用后按电源键彻底关机" },
    { id: 34, recMeasure: "微波炉选择合适容器，避免金属容器加热，提高加热效率降低能耗", emiRedEffect: "每月可减少用电7度，降低碳排放1.7kg，节省电费4元", adaptOffer: "结合您加热需求，推荐使用陶瓷或玻璃容器加热" },
    { id: 35, recMeasure: "吸尘器定期清理尘盒，避免堵塞影响吸力，提高清洁效率降低能耗", emiRedEffect: "每月可减少用电6度，降低碳排放1.4kg，节省电费3元", adaptOffer: "根据您使用频率，推荐每次使用后清理尘盒" },
    { id: 36, recMeasure: "电热水器使用分时供电功能，低谷时段加热蓄水，高峰时段使用，降低电费", emiRedEffect: "每月可减少用电23度，降低碳排放5.4kg，节省电费14元", adaptOffer: "根据您当地电价政策，推荐开启分时供电功能" },
    { id: 37, recMeasure: "路由器关闭不必要的WiFi信号，减少辐射同时降低功率消耗，节约能源", emiRedEffect: "每月可减少用电7度，降低碳排放1.7kg，节省电费4元", adaptOffer: "针对您网络需求，推荐关闭 guest 网络信号" },
    { id: 38, recMeasure: "电饭煲使用后及时清洗内胆，避免食物残留影响加热效率，提高节能效果", emiRedEffect: "每月可减少用电5度，降低碳排放1.2kg，节省电费3元", adaptOffer: "结合您用餐习惯，推荐每次使用后清洗内胆" },
    { id: 39, recMeasure: "电吹风选择折叠式设计，减少体积同时降低功率消耗，节约能源", emiRedEffect: "每月可减少用电4度，降低碳排放0.9kg，节省电费2元", adaptOffer: "根据您使用场景，推荐选择折叠式低功率电吹风" },
    { id: 40, recMeasure: "空气净化器定期更换滤网，提高净化效率，减少风机负载降低能耗", emiRedEffect: "每月可减少用电10度，降低碳排放2.4kg，节省电费6元", adaptOffer: "根据您使用时长，推荐每3-6个月更换一次滤网" }
  ]
  private foodAndDrinkScene: redEmiRecType[] = [
    { id: 1, recMeasure: "减少红肉、加工食品摄入，增加蔬菜、谷物占比，按需做饭避免浪费，优先本地食材", emiRedEffect: "每月可减少碳排放12.0kg，同时提升饮食健康度", adaptOffer: "结合您日均红肉150g，推荐逐步降至50g内搭配本地蔬菜" },
    { id: 2, recMeasure: "多吃当季蔬菜水果，减少反季节食材消费，优先选择本地农产品，降低运输碳排放", emiRedEffect: "每月可减少碳排放9.5kg，同时摄入更多营养物质", adaptOffer: "根据您所在季节，推荐选择当季本地蔬菜水果" },
    { id: 3, recMeasure: "减少外卖点餐次数，自己做饭，避免一次性餐具浪费，降低包装碳排放", emiRedEffect: "每月可减少碳排放8.2kg，同时节省餐饮费用约20%", adaptOffer: "结合您每周3次外卖习惯，推荐减少至1次以内" },
    { id: 4, recMeasure: "适量摄入蛋白质，选择豆类、蛋类替代部分红肉，减少畜牧业碳排放", emiRedEffect: "每月可减少碳排放10.3kg，同时改善血脂水平", adaptOffer: "针对您日均红肉摄入，推荐用豆腐、鸡蛋替代部分肉类" },
    { id: 5, recMeasure: "按需采购食材，避免过量购买导致食物腐烂浪费，减少粮食生产碳排放", emiRedEffect: "每月可减少碳排放7.8kg，同时节省 grocery 费用约15%", adaptOffer: "根据您家庭人口，推荐制定每周采购计划避免浪费" },
    { id: 6, recMeasure: "多吃全谷物食品，替代精制米面，提高膳食纤维摄入，同时降低加工碳排放", emiRedEffect: "每月可减少碳排放6.5kg，同时改善肠道健康", adaptOffer: "结合您主食习惯，推荐用燕麦、糙米替代部分白米" },
    { id: 7, recMeasure: "减少含糖饮料摄入，多喝白开水，避免饮料生产和包装产生的碳排放", emiRedEffect: "每月可减少碳排放5.3kg，同时降低糖分摄入", adaptOffer: "针对您日均1瓶饮料习惯，推荐替换为白开水或茶水" },
    { id: 8, recMeasure: "优先选择散装食材，避免过度包装食品，减少塑料包装产生的碳排放", emiRedEffect: "每月可减少碳排放4.7kg，同时减少塑料垃圾污染", adaptOffer: "根据您购物习惯，推荐选择散装米、面、杂粮等食材" },
    { id: 9, recMeasure: "适量饮酒，减少酒精饮品消费，降低酿酒工业产生的碳排放和水资源消耗", emiRedEffect: "每月可减少碳排放3.9kg，同时保护肝脏健康", adaptOffer: "结合您饮酒频率，推荐每周不超过1次适量饮酒" },
    { id: 10, recMeasure: "多吃豆类及豆制品，替代部分肉类，减少畜牧业碳排放同时补充优质蛋白", emiRedEffect: "每月可减少碳排放11.2kg，同时降低胆固醇摄入", adaptOffer: "针对您饮食结构，推荐每天摄入50g豆类或豆制品" },
    { id: 11, recMeasure: "避免食物浪费，剩余饭菜合理保存，二次加工食用，减少粮食生产碳排放", emiRedEffect: "每月可减少碳排放7.1kg，同时提高食材利用率", adaptOffer: "根据您用餐剩余情况，推荐将剩菜做成炒饭或烩菜食用" },
    { id: 12, recMeasure: "优先选择有机农产品，减少化肥农药使用，降低农业生产碳排放和环境污染", emiRedEffect: "每月可减少碳排放6.8kg，同时摄入更健康的食材", adaptOffer: "结合您预算，推荐优先选择有机蔬菜和水果" },
    { id: 13, recMeasure: "减少零食消费，尤其是加工零食，避免过度包装和生产过程碳排放", emiRedEffect: "每月可减少碳排放5.9kg，同时减少添加剂摄入", adaptOffer: "针对您零食习惯，推荐用坚果、水果替代加工零食" },
    { id: 14, recMeasure: "多吃深色蔬菜，如菠菜、西兰花，提高维生素摄入，同时降低种植碳排放", emiRedEffect: "每月可减少碳排放4.3kg，同时增强免疫力", adaptOffer: "根据您蔬菜摄入，推荐每天摄入200g深色蔬菜" },
    { id: 15, recMeasure: "适量摄入乳制品，选择低脂牛奶，减少畜牧业碳排放同时补充钙质", emiRedEffect: "每月可减少碳排放3.5kg，同时维持骨骼健康", adaptOffer: "结合您乳制品需求，推荐每天摄入250ml低脂牛奶" },
    { id: 16, recMeasure: "避免暴饮暴食，控制饮食量，减少食物浪费同时降低消化代谢碳排放", emiRedEffect: "每月可减少碳排放6.2kg，同时控制体重", adaptOffer: "根据您用餐量，推荐七八分饱避免过量进食" },
    { id: 17, recMeasure: "优先选择本地养殖的水产品，减少长途运输碳排放，保证食材新鲜度", emiRedEffect: "每月可减少碳排放8.7kg，同时摄入更多Omega-3", adaptOffer: "针对您海鲜需求，推荐选择本地养殖鱼类和虾类" },
    { id: 18, recMeasure: "多吃发酵食品，如酸奶、泡菜，改善肠道菌群，同时降低食品加工碳排放", emiRedEffect: "每月可减少碳排放5.1kg，同时促进消化吸收", adaptOffer: "结合您饮食偏好，推荐每天摄入100g发酵食品" },
    { id: 19, recMeasure: "减少油炸食品摄入，选择蒸、煮、炖的烹饪方式，降低烹饪过程碳排放", emiRedEffect: "每月可减少碳排放7.4kg，同时减少油脂摄入", adaptOffer: "针对您烹饪习惯，推荐用蒸煮炖替代油炸煎炒" },
    { id: 20, recMeasure: "按需做饭，根据用餐人数准备食材，避免剩余过多导致食物浪费", emiRedEffect: "每月可减少碳排放6.9kg，同时提高用餐体验", adaptOffer: "根据您家庭人口，推荐精准计算食材用量做饭" },
    { id: 21, recMeasure: "多吃全谷物面包，替代精制面包，提高膳食纤维摄入，同时降低加工碳排放", emiRedEffect: "每月可减少碳排放4.8kg，同时稳定血糖水平", adaptOffer: "结合您早餐习惯，推荐选择全麦面包替代白面包" },
    { id: 22, recMeasure: "减少含糖糕点摄入，选择水果作为甜点，避免糖分和包装产生的碳排放", emiRedEffect: "每月可减少碳排放5.5kg，同时减少热量摄入", adaptOffer: "针对您甜点需求，推荐用新鲜水果替代蛋糕饼干" },
    { id: 23, recMeasure: "优先选择散装茶叶，避免过度包装，减少茶叶生产和包装碳排放", emiRedEffect: "每月可减少碳排放3.2kg，同时享受更纯粹的茶香", adaptOffer: "根据您饮茶习惯，推荐选择散装茶叶替代袋泡茶" },
    { id: 24, recMeasure: "多吃根茎类蔬菜，如土豆、胡萝卜，适应本地气候，降低种植碳排放", emiRedEffect: "每月可减少碳排放4.1kg，同时补充碳水化合物", adaptOffer: "结合您蔬菜种类，推荐增加根茎类蔬菜摄入" },
    { id: 25, recMeasure: "减少加工肉制品摄入，如香肠、火腿，避免腌制过程产生的碳排放", emiRedEffect: "每月可减少碳排放9.2kg，同时减少亚硝酸盐摄入", adaptOffer: "针对您肉类选择，推荐用新鲜肉类替代加工肉制品" },
    { id: 26, recMeasure: "适量摄入坚果，作为健康零食，减少畜牧业碳排放同时补充健康脂肪", emiRedEffect: "每月可减少碳排放3.7kg，同时保护心血管健康", adaptOffer: "结合您零食习惯，推荐每天摄入10g坚果" },
    { id: 27, recMeasure: "避免购买大包装食品，尤其是易腐烂食材，减少因吃不完导致的浪费", emiRedEffect: "每月可减少碳排放5.7kg，同时保证食材新鲜度", adaptOffer: "根据您食用速度，推荐选择小包装易腐烂食材" },
    { id: 28, recMeasure: "多吃绿叶蔬菜，如生菜、油麦菜，生长周期短，降低种植碳排放", emiRedEffect: "每月可减少碳排放4.5kg，同时补充维生素K", adaptOffer: "针对您蔬菜摄入，推荐每天摄入150g绿叶蔬菜" },
    { id: 29, recMeasure: "减少酒精饮料摄入，尤其是高度酒，降低酿酒工业碳排放和水资源消耗", emiRedEffect: "每月可减少碳排放4.0kg，同时保护肝脏功能", adaptOffer: "结合您饮酒习惯，推荐用无酒精饮料替代酒类" },
    { id: 30, recMeasure: "优先选择本地蜂蜜，替代进口蜂蜜，减少运输碳排放同时支持本地农业", emiRedEffect: "每月可减少碳排放2.8kg，同时摄入更纯净的蜂蜜", adaptOffer: "根据您蜂蜜需求，推荐选择本地养蜂场的蜂蜜" },
    { id: 31, recMeasure: "多吃豆类汤品，如绿豆汤、红豆汤，补充水分同时降低畜牧业碳排放", emiRedEffect: "每月可减少碳排放6.3kg，同时清热解暑", adaptOffer: "结合您季节需求，推荐夏季多喝豆类汤品" },
    { id: 32, recMeasure: "减少外卖包装浪费，选择自带餐具，避免一次性餐具产生的碳排放", emiRedEffect: "每月可减少碳排放3.3kg，同时减少塑料垃圾", adaptOffer: "针对您外卖需求，推荐自带餐具避免使用一次性餐具" },
    { id: 33, recMeasure: "适量摄入水果，每天200-350g，避免过量购买导致腐烂浪费", emiRedEffect: "每月可减少碳排放5.2kg，同时补充维生素C", adaptOffer: "根据您水果需求，推荐每天购买适量新鲜水果" },
    { id: 34, recMeasure: "优先选择本地鸡蛋，替代进口鸡蛋，减少运输碳排放同时保证新鲜度", emiRedEffect: "每月可减少碳排放3.0kg，同时补充优质蛋白", adaptOffer: "结合您鸡蛋需求，推荐选择本地养殖场的鸡蛋" },
    { id: 35, recMeasure: "多吃全谷物粥品，如小米粥、燕麦粥，替代精制粥品，提高膳食纤维摄入", emiRedEffect: "每月可减少碳排放4.6kg，同时养胃护胃", adaptOffer: "结合您早餐习惯，推荐用全谷物粥替代白粥" },
    { id: 36, recMeasure: "减少含糖酸奶摄入，选择原味酸奶，避免添加糖和包装产生的碳排放", emiRedEffect: "每月可减少碳排放3.8kg，同时减少糖分摄入", adaptOffer: "针对您酸奶选择，推荐用原味酸奶替代风味酸奶" },
    { id: 37, recMeasure: "避免食物过度烹饪，选择简单烹饪方式，保留营养同时降低烹饪碳排放", emiRedEffect: "每月可减少碳排放6.1kg，同时保留食材营养", adaptOffer: "结合您烹饪方式，推荐选择快炒、蒸煮等简单方式" },
    { id: 38, recMeasure: "多吃本地食用菌，如香菇、平菇，生长周期短，降低种植碳排放", emiRedEffect: "每月可减少碳排放4.2kg，同时补充多糖类物质", adaptOffer: "针对您蔬菜种类，推荐增加本地食用菌摄入" },
    { id: 39, recMeasure: "减少瓶装水消费，选择自来水过滤饮用，减少塑料瓶生产碳排放", emiRedEffect: "每月可减少碳排放2.5kg，同时减少塑料垃圾污染", adaptOffer: "结合您饮水习惯，推荐用滤水壶过滤自来水饮用" },
    { id: 40, recMeasure: "适量摄入粗粮，如玉米、紫薯，替代部分精制主食，降低加工碳排放", emiRedEffect: "每月可减少碳排放5.0kg，同时改善便秘问题", adaptOffer: "根据您主食结构，推荐每天摄入50g粗粮" }
  ]

  // 随机获取各场景一个元素，拼接成字符串返回
  public getRandomTips(): redEmiRecType[] {
    const getRandomItem = (arr: redEmiRecType[]) => {
      return arr[Math.floor(Math.random() * arr.length)]
    }

    const transport = getRandomItem(this.transportScene)
    const appliance = getRandomItem(this.applianceScene)
    const food = getRandomItem(this.foodAndDrinkScene)

    const dataList: redEmiRecType[] = []
    dataList.push(transport)
    dataList.push(appliance)
    dataList.push(food)
    return dataList
  }
}

const tipsModel = new LittleTipsModel()

export default tipsModel