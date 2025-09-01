+++
title = 'FTXUI Component 模块'
description = '本篇文章主要讲解一下 FTXUI Component 模块'
tags = ['FTXUI Self-Study Guide', 'C++', '编程教程', 'TUI']
keywords = ['FTXUI Self-Study Guide', 'C++', '编程教程', '后端开发', '零基础', '计算机编程', 'FTXUI', 'GCC', 'GDB', 'CMake', 'VS Code', 'CLion', 'TUI']
date = 2025-09-01T13:50:00+08:00
categories = ['FTXUI 自学指南']
+++

`ftxui::Component` 模块定义了生成交互式组件的逻辑，这些组件可以响应用户发起的事件(鼠标、键盘)。

`ftxui::ScreenInteractive` 定义了一个渲染组件的主循环。
`ftxui::Component` 是 `ftxui::ComponentBase` 的共享指针。后者定义了:

*	**`ftxui::ComponentBase::Render()`** 如何渲染界面
*	**`ftxui::ComponentBase::OnEvent()`** 如何响应事件
*	**`ftxui::ComponentBase::Add()`** 两个组件之间构建父子关系，组件树用于定义如何使用键盘导航。

`ftxui::Element` 用于渲染单个帧
`ftxui::Component` 用于渲染动态用户界面 生成多个帧 并在事件发生时更新其状态。

## Input

用于实现用户输入框

[代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2input_8cpp-example.html)

![Input Demo](/Image/FTXUI%20Self-Study%20Guide/Input%20Demo.png)

### 过滤输入

可以使用 `ftxui::CatchEvent` 过滤输入组件接收到的字符

```cpp
std::string phone_number;
Component input = Input(&phone_number, "phone number");
 
// 过滤掉非数字字符
input |= CatchEvent([&](Event event) {
  return event.is_character() && !std::isdigit(event.character()[0]);
});
 
// 过滤掉第10个字符之后的字符
input |= CatchEvent([&](Event event) {
  return event.is_character() && phone_number.size() >= 10;
});
```

## Menu

定义一个菜单对象，它包含一个条目列表。

[代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2menu_8cpp-example.html)

## Toggle

一种特殊菜单 条目水平显示

[代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2toggle_8cpp-example.html)

## CheckBox

定义一个复选框(多选框)

[代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2checkbox_8cpp-example.html)

## RadioBox

定义一个单选框

[代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2radiobox_8cpp-example.html)

## Dropdown

下拉菜单组件

[代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2dropdown_8cpp-example.html)

## Slider

滑块组件

[代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2slider_8cpp-example.html)

## Renderer

通过使用不同的函数来渲染界面装饰另一个组件

```cpp
auto inner = [...]
 
auto renderer = Renderer(inner, [&] {
  return inner->Render() | border
});
```

装饰器模式

```cpp
auto component = [...]
component = component
  | Renderer([](Element e) { return e | border))
  | Renderer(bold)
```

组件与装饰器组合

```cpp
auto component = [...]
component = component | border | bold;
```

## CatchEvent

在底层组件之前捕获事件

```cpp
auto screen = ScreenInteractive::TerminalOutput();
auto renderer = Renderer([] {
  return text("My interface");
});
auto component = CatchEvent(renderer, [&](Event event) {
  if (event == Event::Character('q')) {
    screen.ExitLoopClosure()();
    return true;
  }
  return false;
});
screen.Loop(component);
```

用作装饰器

```cpp
component = component
  | CatchEvent(handler_1)
  | CatchEvent(handler_2)
  | CatchEvent(handler_3)
  ;
```

## Collapsible

对于用户可以切换可见性的视觉元素很有用，本质上这是 `ftxui::Checkbox()` 和 `ftxui::Maybe()` 组件的组合

```cpp
auto collapsible = Collapsible("Show more", inner_element);
```

## Maybe

此组件可以通过布尔值或谓词来显示/隐藏任何其它组件

布尔值示例:

```cpp
bool show = true;
auto component = Renderer([]{ return "Hello World!"; });
auto maybe_component = Maybe(component, &show)
```

谓词示例:

```cpp
auto component = Renderer([]{ return "Hello World!"; });
auto maybe_component = Maybe(component, [&] { return time > 10; })
```

装饰器示例:

```cpp
component = component
  | Maybe(&a_boolean)
  | Maybe([&] { return time > 10; })
  ;
```

## Container

### Horizontal

它水平显示组件列表

### Vertical

它垂直显示组件列表

### Tab

它接受一个组件列表并只显示其中一个

[垂直列表代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2tab_vertical_8cpp-example.html)

[水平列表代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2tab_horizontal_8cpp-example.html)

## ResizableSplit

它定义了两个子组件之间的水平或垂直分隔，其分隔位置是可变的，并可以使用鼠标控制。

四种分隔方式:

*	**`ftxui::ResizableSplitLeft()`**
*	**`ftxui::ResizableSplitRight()`**
*	**`ftxui::ResizableSplitTop()`**
*	**`ftxui::ResizableSplitBottom()`**

[代码](https://arthursonzogni.github.io/FTXUI/examples_2component_2resizable_split_8cpp-example.html)

## 强制一个帧重新绘制

通常 `ftxui::ScreenInteractive::Loop()` 负责在处理完新的一组事件（例如键盘、鼠标、窗口大小调整等）时绘制新帧。但是，您可能希望对 FTXUI 未知的任意事件做出反应。为此，您必须通过线程使用 `ftxui::ScreenInteractive::PostEvent` 这是线程安全的发布事件。您将不得不发布事件 `ftxui::Event::Custom`

**示例**

```cpp
screen->PostEvent(Event::Custom);
```

如果您不需要处理新事件，可以使用:

```cpp
screen->RequestAnimationFrame();
```

代替