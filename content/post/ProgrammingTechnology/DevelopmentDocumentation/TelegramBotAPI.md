+++
title = 'Telegram Bot API'
date = 2025-08-18T18:26:08+08:00
description = '本篇文章主要是将 Telegram Bot API 的官方文档进行了整理与汉化方便各位开发者能够更好的对接'
tags = ['Telegram Bot API', 'C++', 'HTTP/HTTPS', 'API', 'Docs']
keywords = ['Telegram Bot API', 'C++', 'HTTP', 'HTTPS', 'Docs', '文档', '教程', 'API', '接口', '汉化', 'CLion']
categories = ['开发文档']
+++

## 创建 Telegram Bot

1. 在 Telegram 中搜索 [@BotFather](https://t.me/BotFather)
2. 在对话框中发送 `/newbot`
3. 输入机器人名称 (用作称呼)
4. 输入机器人用户名以 (bot/Bot) 结尾 (用作机器人账号)
5. 接下来你就会获得一串 Token (请勿泄漏 拥有 Token 就代表掌握了 Bot 的绝对权限)

## 测试 Telegram Bot

```
https://api.telegram.org/bot<YourToken>/getMe
```

将 &lt;YourToken&gt; 替换为你 Bot 的完整 Token，复制到浏览器即可查看到 Bot 的相关信息。

对于 Telegram Bot API 的所有操作都必须通过 HTTPS 进行通信，并且需要使用以下形式呈现:

```
https://api.telegram.org/bot<YourToken>/方法名称
```

## 使用本地 Bot API Server

Bot API 服务器源代码可在 [Telegram-Bot-API](https://github.com/tdlib/telegram-bot-api) 处获得。您可以在本地运行它,并将请求发送到您自己的服务器,而不是 https://api.telegram.org 如果切换到本地 Bot API 服务器,您的机器人将能够:

* 下载没有大小限制的文件。
* 上传文件高达2000 MB。
* 使用其本地路径和文件 URI 方案上传文件。
* 使用 HTTP URL 进行 webhook。
* 使用任何本地 IP 地址的 webhook。
* 使用任何端口的webhook。
* 设置 max_webhook_connections 高达 100000。
* 接收绝对本地路径作为 file_path 字段的值,无需在 getFile 请求后下载文件。

## 获取更新

有两种互斥的方式可以接收机器人的更新 —— 一种是getUpdates方法，另一种是网络钩子（webhooks）。传入的更新会存储在服务器上，直到机器人通过这两种方式中的任意一种接收它们，但这些更新的保存时间不会超过 24 小时。

无论你选择哪种方式，最终都会收到 JSON 序列化的 Update 对象。

### Update - 更新

> 该对象表示一个传入的更新。在任何给定的更新中，最多只能有一个可选参数存在。

|字段|类型|描述|
|---|---|---|
|`update_id`|整数|更新的唯一标识符 从特定正数开始依次递增 使用网络钩子时可忽略重复更新或恢复顺序 若一周无更新则下个ID随机生成|
|`message`|[消息](#message)|**可选** 新收到的文本、照片、贴纸等消息|
|`edited_message`|[消息](#message)|**可选** 已知消息被编辑后的新版本|
|`channel_post`|[消息](#message)|**可选** 新收到的频道帖子|
|`edited_channel_post`|[消息](#message)|**可选** 已知频道帖子被编辑后的新版本|
|`business_connection`|[业务连接](#businessconnection)|**可选** 机器人连接/断开业务账户或用户编辑连接时触发|
|`business_message`|[消息](#message)|**可选** 来自业务账户的新消息|
|`edited_business_message`|[消息](#message)|**可选** 业务账户消息被编辑后的版本|
|`deleted_business_messages`|[业务消息已删除](#businessmessagesdeleted)|**可选** 业务账户消息被删除时触发|
|`message_reaction`|[消息反应已更新](#messagereactionupdated)|**可选** 用户更改消息反应（需管理员权限并在`allowed_updates`指定）|
|`message_reaction_count`|[消息反应计数已更新](#messagereactioncountupdated)|**可选** 匿名消息反应数变更（需管理员权限并在`allowed_updates`指定 可能延迟）|
|`inline_query`|[内联查询](#inlinequery)|**可选** 新收到的内联查询|
|`chosen_inline_result`|[选择的内联结果](#choseninlineresult)|**可选** 用户选择内联结果并发送|
|`callback_query`|[回调查询](#callbackquery)|**可选** 新收到的回调查询|
|`shipping_query`|[物流查询](#shippingquery)|**可选** 新物流查询（仅灵活价格发票）|
|`pre_checkout_query`|[预结账查询](#precheckoutquery)|**可选** 新预结账查询（含完整信息）|
|`purchased_paid_media`|[付费媒体已购买](#paidmediapurchased)|**可选** 用户在非频道聊天购买机器人发送的付费媒体|
|`poll`|[投票](#poll)|**可选** 投票状态更新（仅手动停止或机器人发送的投票）|
|`poll_answer`|[投票答案](#pollanswer)|**可选** 用户更改非匿名投票答案（仅机器人发送的投票）|
|`my_chat_member`|[聊天成员已更新](#chatmemberupdated)|**可选** 机器人成员状态更新（私聊中仅触发于屏蔽/解封）|
|`chat_member`|[聊天成员已更新](#chatmemberupdated)|**可选** 成员状态更新（需管理员权限并在`allowed_updates`指定）|
|`chat_join_request`|[加群请求](#chatjoinrequest)|**可选** 加群请求（需`can_invite_users`权限）|
|`chat_boost`|[聊天加速已更新](#chatboostupdated)|**可选** 聊天加速状态新增/变更（需管理员权限）|
|`removed_chat_boost`|[聊天加速已移除](#chatboostremoved)|**可选** 聊天加速状态移除（需管理员权限）|

### getUpdates - 获取更新

> 使用此方法通过长轮询接收传入的更新。返回一个由 Update 对象组成的数组。

|参数|类型|必填|描述|
|---|---|---|---|
|`offset`|整数|**可选**|要返回的第一个更新标识符<br>• 必须比已接收的最高ID大1<br>• 默认返回最早未确认更新<br>• 负值获取队列末尾更新（如`-5`获取最后5条）|
|`limit`|整数|**可选**|获取更新数量限制<br>• 范围：1-100<br>• 默认值：100|
|`timeout`|整数|**可选**|长轮询超时时间（秒）<br>• 0=短轮询（默认）<br>• 正值=长轮询等待时间<br>• 短轮询仅建议测试使用|
|`allowed_updates`|字符串数组|**可选**|允许接收的更新类型（JSON格式）<br>• 示例：`["message","callback_query"]`<br>• 空数组=接收除三类敏感更新外的所有类型<br>• 不设置=沿用上次配置<br>• 注意：不影响调用前已生成的更新|