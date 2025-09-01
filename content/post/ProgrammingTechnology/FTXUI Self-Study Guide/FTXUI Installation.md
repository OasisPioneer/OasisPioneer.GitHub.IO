+++
title = 'FTXUI 安装'
description = '本篇文章主要讲解 FTXUI 框架所支持的构建系统与包管理器的集成方式'
tags = ['FTXUI Self-Study Guide', 'C++', '编程教程', 'TUI']
keywords = ['FTXUI Self-Study Guide', 'C++', '编程教程', '后端开发', '零基础', '计算机编程', 'GCC', 'GDB', 'CMake', 'VS Code', 'CLion', 'TUI']
date = 2025-08-27T20:30:00+08:00
categories = ['FTXUI 自学指南']
+++

FTXUI 可以使用多种构建系统和包管理器集成到您的项目中

## 所支持的方式

*	[**CMake**](#cmake)
*	[**Bazel**](#bazel)
*	[**VcPkg**](#vcpkg)
*	[**Debian/Ubuntu**](#debianubuntu)

## CMake

使用 CMake 的三种集成 FTXUI 方式

### 使用 FetchContent

这种方式会在编译时自动下载 FTXUI，不需要在系统上安装

```cmake
include(FetchContent)
 
FetchContent_Declare(ftxui
  GIT_REPOSITORY https://github.com/ArthurSonzogni/FTXUI
  GIT_TAG v6.1.9  # Replace with a version, tag, or commit hash
)
 
FetchContent_MakeAvailable(ftxui)
 
add_executable(main main.cpp)
target_link_libraries(main
  PRIVATE ftxui::screen
  PRIVATE ftxui::dom
  PRIVATE ftxui::component
)
```

### 使用 find_package

如果 FTXUI 已系统上安装或通过包管理器（例如 VcPkg 或 Conan）安装，您可以使用此方式

```cmake
find_package(ftxui REQUIRED)
 
add_executable(main main.cpp)
target_link_libraries(main
  PRIVATE ftxui::screen
  PRIVATE ftxui::dom
  PRIVATE ftxui::component
)
```

### 使用 git submodule

将 FTXUI 添加为 Git 子模块，使其成为您仓库的一部分

```bash
git submodule add https://github.com/ArthurSonzogni/FTXUI external/ftxui
git submodule update --init --recursive
```

当克隆一个已经包含 FTXUI 作为子模块的仓库时，请确保使用以下命令获取子模块

```bash
git clone --recurse-submodules <your-repo>
# Or, if already cloned:
git submodule update --init --recursive
```

然后在您的 `CMakeLists.txt` 中添加

```cmake
add_subdirectory(external/ftxui)
 
add_executable(main main.cpp)
target_link_libraries(main
  PRIVATE ftxui::screen
  PRIVATE ftxui::dom
  PRIVATE ftxui::component
)
```

### 可选 CMake 选项

FTXUI 支持以下 CMake 选项

|选项|描述|默认|
|---|---|---|
|FTXUI_BUILD_EXAMPLES|构建捆绑示例|OFF|
|FTXUI_BUILD_DOCS|构建文档|OFF|
|FTXUI_BUILD_TESTS|启用测试|OFF|
|FTXUI_ENABLE_INSTALL|生成安装目标|OFF|
|FTXUI_MICROSOFT_TERMINAL_FALLBACK|改进 Windows 兼容性|ON/OFF|

如果要启用一个选项:

```bash
cmake -DFTXUI_BUILD_EXAMPLES=ON ..
```

## Bazel

FTXUI 可以使用 [Bazel](https://bazel.build/) 和 BzlMod 集成到您的项目中，该库已在 [Bazel Central Registry](https://registry.bazel.build/modules/ftxui) 中注册

### MODULE.Bzael

```bazel
bazel_dep(name = "ftxui", version = "6.1.9")
```

### BUILD.Bazel

```bazel
cc_binary(
    name = "main",
    srcs = ["main.cpp"],
    deps = [
        "@ftxui//:component",
        "@ftxui//:dom",
        "@ftxui//:screen",
    ],
)
```

## VcPkg

要在 VcPkg 中使用 FTXUI 库，你可以将以下内容稍作修改后添加到你的 `VcPkg.Json` 中:

```json
{
  "name": "your-project",
  "version-string": "0.1.0",
  "dependencies": [
    {
        "name": "ftxui",
        "version>=": "6.1.9"
    }
  ]
}
```

### 使用 VcPkg 安装 FTXUI

```bash
vcpkg install --triplet x64-linux  # 或 x64-windows / arm64-osx 等.
```

### 配置构建系统

如果您正在使用 CMake，您可以在 `CMakeLists.txt` 中使用以下内容:

**CMakeLists.txt**

```cmake
cmake_minimum_required(VERSION 3.15)
project(my_project)
 
# Make sure vcpkg toolchain file is passed at configure time
find_package(ftxui CONFIG REQUIRED)
 
add_executable(main main.cpp)
target_link_libraries(main
    PRIVATE ftxui::screen
    PRIVATE ftxui::dom
    PRIVATE ftxui::component
)
```

**Main.CPP**

```cpp
#include <ftxui/component/screen_interactive.hpp>
#include <ftxui/component/component.hpp>
#include <ftxui/component/component_options.hpp>
 
int main() {
  using namespace ftxui;
 
  auto screen = ScreenInteractive::TerminalOutput();
  auto button = Button("Click me", [] { std::cout << "Clicked!\n"; });
 
  screen.Loop(button);
}
```

**配置并构建项目**

```bash
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build build
./build/main
```

## Debian/Ubuntu

在终端中使用以下命令进行安装

```bash
sudo apt-get install libftxui-dev
```

安装后可将以下内容添加到 `CMakeLists.txt` 中:

```cmake
find_package(ftxui REQUIRED)
add_executable(main main.cpp)
target_link_libraries(main
  PRIVATE ftxui::screen
  PRIVATE ftxui::dom
  PRIVATE ftxui::component
)
```