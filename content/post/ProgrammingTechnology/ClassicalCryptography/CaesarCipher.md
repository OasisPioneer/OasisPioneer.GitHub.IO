+++
title = '凯撒密码'
description = '本篇文章主要分享古典密码学的凯撒密码'
tags = ['古典密码学', 'C++']
keywords = ['古典密码学', '凯撒密码', '加密算法', 'C++']
date = 2025-08-11T16:34:53+08:00
categories = ['古典密码']
+++

## 什么是凯撒密码？

凯撒密码是一种**替换密码（Substitution Cipher）**，也被称为**移位密码（Shift Cipher）**。它的加密过程非常简单：将明文中的每一个字母，用字母表上固定距离的另一个字母来替换。

这个“固定的距离”就是加密的**密钥（Key）**。

例如，如果我们选择的密钥是 **3**，那么：
- 字母 `A` 会被替换成字母表中向后移动 3 位的 `D`。
- 字母 `B` 会被替换成 `E`。
- ...
- 字母 `X` 会被替换成 `A`（因为 `X` -> `Y` -> `Z` -> `A`，字母表是循环的）。
- 字母 `Y` 会被替换成 `B`。
- 字母 `Z` 会被替换成 `C`。

这个过程就像是将整个字母表向左平移了 3 位，形成了一个新的对应关系。

**加密示例 (密钥 = 3):**
- **明文 (Plaintext):** `HELLO WORLD`
- **密文 (Ciphertext):** `KHOOR ZRUOG`

## 凯撒密码的数学表示

尽管凯撒密码很简单，但我们依然可以用数学语言来精确地描述它。我们将字母表中的每个字母映射为一个数字（例如，A=0, B=1, ..., Z=25）。

设：
- `P` 为明文字母对应的数字。
- `C` 为密文字母对应的数字。
- `k` 为密钥（位移量）。

那么，加密过程可以表示为：
$$ C = (P + k) \pmod{26} $$

解密过程则是加密的逆运算，即向前移动 `k` 位：
$$ P = (C - k) \pmod{26} $$

这里的 `mod 26` (模26) 运算是关键，它完美地实现了字母表的循环。例如，当加密 `X` (23) 且密钥为 `3` 时：
`C = (23 + 3) mod 26 = 26 mod 26 = 0`，对应的字母是 `A`。

当解密 `A` (0) 且密钥为 `3` 时：
`P = (0 - 3) mod 26 = -3 mod 26`。在模运算中，-3 和 23 是同余的，所以结果是 `23`，对应的字母是 `X`。

## 如何破解凯撒密码？

凯撒密码的安全性极低，因为它存在致命的弱点。主要有两种破解方法：

### 1. 暴力破解 (Brute-force Attack)

由于英文字母只有 26 个，所以可能的密钥也只有 25 种（密钥为 0 或 26 没有意义，因为明文和密文会一样）。攻击者可以简单地将所有可能的密钥（从 1 到 25）全部尝试一遍，直到解密出的文本有意义为止。这个过程对于计算机来说是瞬时完成的。

### 2. 频率分析 (Frequency Analysis)

在任何一种自然语言中，不同字母的出现频率是有统计规律的。例如，在英语中，字母 `E` 的出现频率最高，其次是 `T`, `A`, `O` 等。

攻击者可以统计密文中每个字母的出现频率，找到出现次数最多的那个密文字母。它有极大的概率对应明文中的 `E`。一旦确定了这一对映射关系（比如密文 `H` 对应明文 `E`），就可以立即推算出密钥 `k`（从 `E` 到 `H` 的位移是 3），从而破解整个密码。

## C++ 代码实现

下面是一个完整的 C++ 程序，它实现了凯撒密码的加密和解密功能。代码结构清晰，并包含了详细的注释。

```cpp
#include <iostream>
#include <string>
#include <cctype>

std::string caesarEncrypt(const std::string& text, int shift);
std::string caesarDecrypt(const std::string& text, int shift);

int main() {
    std::string message;
    int shift;

    std::cout << "=====================================" << std::endl;
    std::cout << "      凯撒密码加密/解密程序" << std::endl;
    std::cout << "=====================================" << std::endl;

    std::cout << "\n请输入要处理的消息: ";
    std::getline(std::cin, message);

    std::cout << "请输入移位量 (0-25 之间的整数): ";
    std::cin >> shift;

    shift = shift % 26;
    if (shift < 0) {
        shift += 26;
    }

    std::string encryptedMessage = caesarEncrypt(message, shift);
    std::cout << "\n加密后的密文是: " << encryptedMessage << std::endl;

    std::string decryptedMessage = caesarDecrypt(encryptedMessage, shift);
    std::cout << "解密后的明文是: " << decryptedMessage << std::endl;

    return 0;
}

/**
 * @brief 对给定的文本进行凯撒加密
 * @param text 要加密的明文
 * @param shift 移位密钥 (0-25)
 * @return 加密后的密文
 */
std::string caesarEncrypt(const std::string& text, int shift) {
    std::string result = "";
    for (char c : text) {
        if (isalpha(c)) {
            char base = isupper(c) ? 'A' : 'a';
            // Apply encryption formula: C = (P + k) % 26
            result += static_cast<char>((c - base + shift) % 26 + base);
        } else {
            result += c;
        }
    }
    return result;
}

/**
 * @brief 对给定的文本进行凯撒解密
 * @param text 要解密的密文
 * @param shift 移位密钥 (0-25)
 * @return 解密后的明文
 */
std::string caesarDecrypt(const std::string& text, int shift) {
    std::string result = "";
    for (char c : text) {
        if (isalpha(c)) {
            char base = isupper(c) ? 'A' : 'a';
            result += static_cast<char>((c - base - shift + 26) % 26 + base);
        } else {
            result += c;
        }
    }
    return result;
}
```