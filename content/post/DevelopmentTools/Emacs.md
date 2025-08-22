+++
title = 'Emacs'
description = '本篇文章主要分享 Linux 平台 Emacs 编辑器的安装教程'
tags = ['开发工具', '安装配置']
keywords = ['开发工具', '安装配置', 'Emacs', 'Emacs安装教程', 'Emacs配置教程', 'Emacs安装配置', '编辑器', '代码编辑器', 'Code', 'Code Editor']
date = 2025-08-22T15:15:00+08:00
categories = ['开发工具']
+++

## 什么是 Emacs

Emacs 是一个功能极其强大的、可扩展的文本编辑器。

Emacs诞生于1970年代，由著名的计算机科学家理查德·斯托曼（Richard Stallman）创造。它是自由软件运动的标志性项目之一，对后来的很多软件开发理念产生了深远影响。

它内置了一种名为 Emacs Lisp 的编程语言（是Lisp语言的一种方言）。用户可以通过编写 Emacs Lisp 代码来修改编辑器的任何行为，从简单的颜色主题、快捷键，到增加全新的功能模块。这意味着你可以把 Emacs 打造成任何你想要的样子。

由于其强大的扩展性，Emacs 的功能早已超越了编辑文本的范畴。通过各种插件（Packages），你可以在 Emacs 内部完成几乎所有日常的电脑操作，例如：

1. 编程：支持几乎所有编程语言，提供语法高亮、代码补全、调试等功能。
2. 收发邮件：使用 mu4e 或 notmuch 等插件。
3. 文件管理：使用 dired 模式，可以像在文件管理器中一样操作文件和目录。
4. 日程管理和笔记：使用强大的 org-mode，这是 Emacs 的“杀手级应用”，可以用来写文档、做笔记、管理待办事项、制定项目计划等。
5. 版本控制：通过 Magit 插件，可以获得顶级的 Git 操作体验。
6. 浏览网页、听音乐、聊天，甚至玩游戏。

> Emacs 可以在几乎所有的操作系统上运行，包括 Linux、macOS 和 Windows。

Emacs 不仅仅是一个让你写代码或文章的工具，它更像一个为你量身定做的工作环境。你可以根据自己的需求，把它打造成一个极简的写作工具，或者一个无所不能的“瑞士军刀”。它的学习曲线比较陡峭，但一旦掌握，它将为你提供无与伦-比的自由度和工作效率。

## Emacs 安装教程

以 Ubuntu/Debian 为例，按下快捷键 <kbd>CTRL</kbd> + <kbd>ALT</kbd> + <kbd>T</kbd> 打开终端(控制台)，输入如下命令:

```bash
sudo apt-get update					# 更新本地软件列表
sudo apt-get install emacs 			# 安装 Emacs
```

![邮件配置截图](Image/DevelopmentTools/InstallationProcess/Emacs/Email%20Configuration.png)

上方截图主要意思是你是否需要配置邮件功能

*	**No configuration** 不配置
*	**Internet site** 互联网站点(将本机变成邮件服务器[**需要公网IP**])
*	**Internet with smarthost** 将邮件中转发送到网络邮件服务器
*	**Satellite system** 卫星系统(将邮件转发到中央邮件服务器)

根据自己喜好或需求选择然后按下<kbd>Enter</kbd>继续安装。