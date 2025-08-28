+++
title = 'FTXUI 介绍'
description = '本篇文章主要介绍一下 FTXUI 框架'
tags = ['FTXUI Self-Study Guide', 'C++', '编程教程', 'TUI']
keywords = ['FTXUI Self-Study Guide', 'C++', '编程教程', '后端开发', '零基础', '计算机编程', '开发环境配置', 'GCC', 'GDB', 'CMake', 'VS Code', 'CLion', 'TUI']
date = 2025-08-27T20:00:00+08:00
categories = ['FTXUI 自学指南']
+++

![FTXUI Demo](Image/FTXUI%20Self-Study%20Guide/FTXUI%20Demo.gif)

FTXUI 是一个极具特色的跨平台 C++ TUI（Terminal User Interface，终端用户界面）界面库，专门用于打造基于终端的用户界面。

*	**函数式风格** 设计灵感源于 “Building Reactive Terminal Interfaces in C++” 和 React，采用函数式风格进行构建。这种风格使得代码逻辑更加清晰，易于理解和维护。开发者可以像搭建积木一样，通过组合不同的函数来构建复杂的用户界面，大大提高了开发效率
*	**无第三方依赖** 该框架最大的优势之一就是不依赖任何第三方库。这意味着在项目开发过程中，无需担心因第三方库的版本兼容性问题而导致的各种错误，也减少了项目的复杂度和维护成本。开发者可以更加专注于业务逻辑的实现，快速搭建出稳定可靠的终端应用。
*	**跨平台** FTXUI 支持多种主流操作系统，包括 Linux、MacOS、Windows 以及 WebAssembly。无论是在服务器端的 Linux 环境中，还是在个人电脑的 Windows 或 MacOS 系统上，甚至是在 Web 端通过 WebAssembly 运行，FTXUI 都能保证应用的一致性和稳定性。这使得开发者能够轻松将应用部署到不同的平台，满足更广泛用户的需求。
*	**语法简洁** 通过操作符重载（如管道符 |），可以链式地为界面元素添加样式和布局属性，代码表达力强。
*	**支持鼠标和键盘操作** 内置对鼠标和键盘事件的支持，可以轻松实现点击、拖拽、滚动等交互操作。
*	**支持 UTF-8 和 全角字符** 支持 UTF-8 编码和全角字符，确保在不同语言环境下都能正确显示。
*	**支持动画和绘图** 支持创建流畅的动画效果和基于字符的图形绘制。

## 示例

```cpp
#include <ftxui/dom/elements.hpp>
#include <ftxui/screen/screen.hpp>
#include <iostream>
 
int main() {
  using namespace ftxui;
 
  // 创建一个包含三个文本元素的文档
  Element document = hbox({
    text("left")   | border,
    text("middle") | border | flex,
    text("right")  | border,
  });
 
  // 创建一个屏幕，宽度全屏，高度自适应
  auto screen = Screen::Create(
    Dimension::Full(),       // 宽度
    Dimension::Fit(document) // 高度
  );
 
  // 将文档渲染到屏幕上
  Render(screen, document);
 
  // 将屏幕打印到控制台
  screen.Print();
}
```

预期输出内容:

```
┌────┐┌────────────────────────────────────┐┌─────┐
│left││middle                              ││right│
└────┘└────────────────────────────────────┘└─────┘
```