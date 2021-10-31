package def

var (
	//tuRingRobotUserId = uint64(2020010701) // year-month-day id 图灵机器人
	//tuRingWelcomeMsg  = "您好，小主人，我是你刚创建的机器人，我已经具备了25项聊天技能，赶快和我聊天试试吧！您现在也可以通过左侧的接入方式，把我接入您的产品中去为您提供服务！"

	OwnThinkRobotUserId = uint64(2020010702) // 思知机器人
	OwnThinkWelcomeMsg  = "知识图谱问答机器人，聊天机器人，基于知识图谱、语义理解等的对话机器人。https://robot.ownthink.com/"

	WeChatRobotUserId = uint64(2020010703) // 小微机器人
	WeChatWelcomeMsg  = "欢迎主人，我是您在微信对话开放平台创建的小微机器人。我已经应用了闲聊服务，您可以随意和我对话哦。https://openai.weixin.qq.com/"
)

// 图灵机器人：http://www.turingapi.com/
// 评价：比较成熟，响应快。但是认证用户也只有100次/天，收费。
// 智能工具：图片搜索、数字计算、预料库、中英互译、聊天对话
// 休闲娱乐：笑话大全、故事大全、成语接龙、新闻咨询、星座运势、脑筋急转弯、歇后语、绕口令、顺口溜
// 生活服务：天气查询、菜谱大全、快递查询、列车查询、日期查询、附近酒店、果蔬报价、汽油报价、股票查询、城市邮编

// 思知机器人：https://www.ownthink.com/
// 评价：响应比较慢，10秒都经常超时，开源但是没找到语料库
// 天气情况、姚明

// 小微机器人（微信对话开放平台）：https://openai.weixin.qq.com/
// 评价：响应比较快，推荐👍👍👍，免费，无次数限制
// 天气：上海天气怎么样，上海今天有雨吗
// 新闻：北京新闻
// 聊天：中午吃啥
// 百科：世界最高峰
// 成语接龙：不可一世
// 家常菜谱：打开菜谱
// 技能总结：你会干什么
// 国内大学排名：国内重点大学排名，虚假大学有那些

// 是否机器人账号
func IsRobot(userId uint64) bool {
	return userId == OwnThinkRobotUserId || userId == WeChatRobotUserId
}
