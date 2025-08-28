+++
title = 'FTXUI Screen 模块'
description = '本篇文章主要讲解一下 FTXUI Screen 模块'
tags = ['FTXUI Self-Study Guide', 'C++', '编程教程', 'TUI']
keywords = ['FTXUI Self-Study Guide', 'C++', '编程教程', '后端开发', '零基础', '计算机编程', '开发环境配置', 'GCC', 'GDB', 'CMake', 'VS Code', 'CLion', 'TUI']
date = 2025-08-27T21:35:00+08:00
categories = ['FTXUI 自学指南']
+++

`ftxui::screen` 模块是 FTXUI 框架的底层核心，它可以独立使用，但主要设计用于与 `ftxui::dom` 和 `ftxui::component` 模块一起使用

## FTXUI::Screen

`ftxui::Screen` 类表示一个二维的样式化字符网格，可以渲染到终端，它提供了创建屏幕，访问像素和渲染元素的方法。

可以使用`ftxui::Screen::PixelAt` 函数来访问屏幕的指定单元格，该函数会返回指定坐标处的像素引用。

**示例**

```cpp
#include <ftxui/screen/screen.hpp>
#include <ftxui/screen/color.hpp>
 
void main() {
    auto screen = ftxui::Screen::Create(
        ftxui::Dimension::Full(),   // 最大宽度
        ftxui::Dimension::Fixed(10) // 固定高度
    );
 
    // 访问 (10, 5) 位置的像素
    auto& pixel = screen.PixelAt(10, 5);
 
    // 设置像素属性
    pixel.character = U'X';
    pixel.foreground_color = ftxui::Color::Red;
    pixel.background_color = ftxui::Color::RGB(0, 255, 0);
    pixel.bold = true;  // 设置粗体样式
    screen.Print(); 	// 将平面打印到终端
}
```

> 如果坐标超出范围将会返回一个虚拟像素

屏幕可以使用 `ftxui::Screen::Print()` 打印到终端，或者使用 `ftxui::Screen::ToString()` 转换为 `std::string` 然后输出到终端。

**Print**

```cpp
auto screen = ...;
screen.Print();
```

**ToString**

```cpp
auto screen = ...;
std::cout << screen.ToString();
```

**示例**

```cpp
auto screen = ...;
while(true) {
  // 绘图操作
  ...
  
  // 将屏幕打印到终端，重置光标位置和屏幕内容
  std::cout << screen.ToString();
  std::cout << screen.ResetCursorPosition(/*clear=*/true);
  std::cout << std::flush;
 
  // 暂停一下以控制屏幕刷新率
  std::this_thread::sleep_for(std::chrono::milliseconds(100));
}
```

## FTXUI::Dimension

`ftxui::Dimension` 工具控制屏幕尺寸

*	**`Dimension::Full()`** 使用屏幕的宽度或高度
*	**`Dimension::Fit()`** 调整大小以适应渲染的 `ftxui::Element`
*	**`Dimension::Fixed()`** 精确使用列或行

这些值将传递给 `ftxui::Screen::Create()`

ftxui::Screen::Create() 提供了两个重载

*	**`Screen::Create(Dimension)`** 将宽高设置为相同类型的维度
*	**`Screen::Create(Dimension Width, Dimension Heighe)`** 允许按轴进行不同的控制。

```cpp
auto screen = ftxui::Screen::Create(
  ftxui::Dimension::Full(),      // 宽度
  ftxui::Dimension::Fixed(10)    // 高度
);
```

创建后渲染一个元素并打印结果

```cpp
ftxui::Render(screen, element);
screen.Print();
```

## FTXUI::Pixel

屏幕网格中的每一个单元格都是一个 `ftxui::Pixel` 它包含了:

*	**Unicode CodePoint (码点)**
	*	`character` (存储要显示的单个字符)
*	**ftxui::Color**
	*	`foreground_color` (前景颜色)
	*	`background_color` (背景颜色)
*	**Booleans** 样式修饰
	*	`blink` 			(闪烁)
	*	`bold`				(粗体)
	*	`dim`				(暗淡)
	*	`italic`			(斜体)
	*	`inverted`			(反色)
	*	`underlined`		(下划线)
	*	`underlined_double`	(双下划线)
	*	`strikethrough`		(删除线)

```cpp
auto screen = ftxui::Screen::Create(
  ftxui::Dimension::Fixed(5),
  ftxui::Dimension::Fixed(5),
);
 
auto& pixel = screen.PixelAt(3, 3);
pixel.character = U'X';
pixel.bold = true;
pixel.foreground_color = ftxui::Color::Red;
pixel.background_color = ftxui::Color::RGB(0, 255, 0);
 
screen.Print();
```

> `PixelAt(x, y)` 执行边界检查并返回指定坐标处像素的引用。如果超出边界，则返回一个虚拟像素引用。

屏幕中的每个单元格都是一个 ftxui::Pixel。您可以使用以下方法修改它们:

```cpp
auto& pixel = screen.PixelAt(x, y);
pixel.character = U'X';
pixel.bold = true;
pixel.foreground_color = Color::Red;
```

## FTXUI::Color

`ftxui::Color` 类用于定义每个 `ftxui::Pixel` 的前景色和背景色。

它支持各种颜色空间和预定义调色板。如果终端不支持请求的颜色，FTXUI 将动态回退到终端中最接近的可用颜色。

**颜色空间**

*	**默认**: `ftxui::Color::Default` 终端默认颜色
*	**16色 调色板**
	*	`ftxui::Color::Black`
	*	`ftxui::Color::Red`
	*	`……`
*	**256色 调色板**
	*	`ftxui::Color::Chartreuse1`
	*	`ftxui::Color::DarkViolet`
*	**真彩色**
	*	`ftxui::Color::RGB(uint8_t red, uint8_t green, uint8_t blue)`
	*	`ftxui::Color::HSV(uint8_t h, uint8_t s, uint8_t v)`