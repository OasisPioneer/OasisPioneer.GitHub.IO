+++
title = '维吉尼亚密码'
description = '本篇文章主要分享古典密码学的维吉尼亚密码'
tags = ['古典密码学', 'C++']
keywords = ['古典密码学', '维吉尼亚密码', '加密算法', 'C++']
date = 2025-08-13T23:36:51+08:00
categories = ['古典密码']
+++

## 什么是维吉尼亚密码？

维吉尼亚密码（Vigenère cipher）是一种**多表替换密码（Polyalphabetic Substitution Cipher）**，它使用一系列凯撒密码组成密码字母表。与凯撒密码（单表替换密码）不同，维吉尼亚密码的加密不再是简单的固定移位，而是根据一个**密钥（Keyword）**的字母来决定每个明文字母的移位量。

维吉尼亚密码在16世纪由意大利外交官吉奥万·巴蒂斯塔·贝拉索（Giovan Battista Bellaso）发明，但后来被误认为是法国密码学家布莱斯·德·维吉尼亚（Blaise de Vigenère）的发明，因此得名。它在密码学史上具有重要地位，因为它在很长一段时间内被认为是不可破解的，被称为“不可破译的密码”（le chiffre indéchiffrable）。

**工作原理：**

维吉尼亚密码的核心思想是使用一个密钥单词。密钥单词的每个字母决定了明文对应位置字母的移位量。当密钥单词的长度不足以覆盖整个明文时，密钥会重复使用。

例如，如果密钥是 `KEY`，明文是 `ATTACKATDAWN`：

1. **重复密钥：** 将密钥重复，使其长度与明文相同。
   明文: `ATTACKATDAWN`
   密钥:  `KEYKEYKEYKEY`

2. **逐字母加密：** 每个明文字母根据其对应密钥字母的移位量进行凯撒加密。
   - 明文 `A` (0) 对应密钥 `K` (10)。 `A` 移位 10 位变成 `K`。
   - 明文 `T` (19) 对应密钥 `E` (4)。 `T` 移位 4 位变成 `X`。
   - 明文 `T` (19) 对应密钥 `Y` (24)。 `T` 移位 24 位变成 `R`。
   - 以此类推。

**加密示例:**
- **明文 (Plaintext):** `ATTACKATDAWN`
- **密钥 (Key):** `LEMON`
- **重复密钥:** `LEMONLEMONLE`
- **密文 (Ciphertext):** `LXFOPVEFRNHR`

## 维吉尼亚密码的数学表示

维吉尼亚密码的加密和解密可以利用模运算来表示。我们将字母表中的每个字母映射为一个数字（例如，A=0, B=1, ..., Z=25）。

设：
- `P_i` 为明文的第 `i` 个字母对应的数字。
- `C_i` 为密文的第 `i` 个字母对应的数字。
- `K_i` 为密钥的第 `i` 个字母对应的数字（密钥循环使用）。

那么，加密过程可以表示为：
$$ C_i = (P_i + K_i) \pmod{26} $$

解密过程则是加密的逆运算：
$$ P_i = (C_i - K_i + 26) \pmod{26} $$

这里的 `mod 26` (模26) 运算确保了结果在 0 到 25 之间，并且处理了负数的情况。例如，当明文 `A` (0) 遇到密钥 `L` (11) 时：
`C = (0 + 11) mod 26 = 11`，对应的字母是 `L`。

当明文 `T` (19) 遇到密钥 `E` (4) 时：
`C = (19 + 4) mod 26 = 23`，对应的字母是 `X`。

## 如何破解维吉尼亚密码？

尽管维吉尼亚密码在很长一段时间内被认为是不可破解的，但它并非绝对安全。相比于凯撒密码和阿特巴希密码，维吉尼亚密码的破解难度大大增加，因为它引入了多表替换，使得简单的频率分析不再有效。然而，如果攻击者能够确定密钥的长度，那么维吉尼亚密码就可以被分解成多个凯撒密码进行破解。

### 1. 确定密钥长度

这是破解维吉尼亚密码最关键的一步。一旦密钥长度 `L` 被确定，密文就可以被分成 `L` 个子密文，每个子密文都是由一个凯撒密码加密的。常用的确定密钥长度的方法有：

#### a. 卡西斯基考试法 (Kasiski Examination)

卡西斯基考试法通过寻找密文中重复出现的字母序列来推测密钥长度。如果一个重复的字母序列在明文中出现，并且它们之间的距离是密钥长度的整数倍，那么在密文中它们也会以相同的形式重复出现。通过计算这些重复序列之间距离的最大公约数（GCD），可以得到密钥长度的可能值。

例如，如果密文中“ABC”重复出现，第一次在位置5，第二次在位置15，那么它们之间的距离是10。如果“XYZ”重复出现，第一次在位置8，第二次在位置28，距离是20。那么密钥长度可能是10和20的公约数，即10或5或2或1。

#### b. 重合指数法 (Index of Coincidence, IC)

重合指数是衡量一段文本中任意两个随机选择的字母相同的概率。对于英文文本，其重合指数约为0.067。对于随机文本或均匀分布的文本，其重合指数约为0.038。

维吉尼亚密码的破解可以利用重合指数。攻击者可以尝试不同的密钥长度 `L`，将密文分成 `L` 个子密文。如果假设的密钥长度是正确的，那么每个子密文都将是一个凯撒密码加密的文本，其重合指数应该接近英文的0.067。通过计算不同假设密钥长度下的子密文的重合指数，最接近0.067的那个长度很可能就是真实的密钥长度。

### 2. 频率分析破解子密文

一旦密钥长度 `L` 被确定，密文就被分解成了 `L` 个独立的凯撒密码。每个子密文都可以使用频率分析法（与破解凯撒密码相同的方法）来单独破解。通过分析每个子密文的字母频率分布，并与英文的字母频率分布进行比较，可以确定每个子密文的移位量，从而推导出密钥的每个字母。

### 3. 组合密钥并解密

当所有子密文的移位量都被确定后，就可以组合这些移位量来得到完整的密钥。然后，使用这个密钥对原始密文进行解密，即可恢复明文。

尽管维吉尼亚密码比凯撒密码更复杂，但它仍然是古典密码学的一部分，在现代密码学中已经不再安全。现代密码学使用更复杂的算法和更长的密钥来确保信息的安全性。

## C++ 代码实现

下面是一个完整的 C++ 程序，它实现了维吉尼亚密码的加密和解密功能。代码结构清晰，并包含了详细的注释。

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <cctype>

// Function to convert a character to its 0-25 integer equivalent
int charToInt(char c) {
    if (isupper(c)) {
        return c - 'A';
    } else if (islower(c)) {
        return c - 'a';
    }
    return -1; // Not an alphabet character
}

// Function to convert an integer (0-25) back to a character
char intToChar(int i, char originalCase) {
    if (isupper(originalCase)) {
        return static_cast<char>('A' + i);
    } else {
        return static_cast<char>('a' + i);
    }
}

std::string vigenereEncrypt(const std::string& plaintext, const std::string& key);
std::string vigenereDecrypt(const std::string& ciphertext, const std::string& key);

int main() {
    std::string message;
    std::string key;

    std::cout << "=====================================" << std::endl;
    std::cout << "      维吉尼亚密码加密/解密程序" << std::endl;
    std::cout << "=====================================" << std::endl;

    std::cout << "\n请输入要处理的消息: ";
    std::getline(std::cin, message);

    std::cout << "请输入密钥 (只包含字母): ";
    std::getline(std::cin, key);

    // Convert key to uppercase for consistent processing
    for (char &c : key) {
        c = toupper(c);
    }

    std::string encryptedMessage = vigenereEncrypt(message, key);
    std::cout << "\n加密后的密文是: " << encryptedMessage << std::endl;

    std::string decryptedMessage = vigenereDecrypt(encryptedMessage, key);
    std::cout << "解密后的明文是: " << decryptedMessage << std::endl;

    return 0;
}

/**
 * @brief 对给定的文本进行维吉尼亚加密
 * @param plaintext 要加密的明文
 * @param key 密钥
 * @return 加密后的密文
 */
std::string vigenereEncrypt(const std::string& plaintext, const std::string& key) {
    std::string ciphertext = "";
    int keyIndex = 0;
    for (char pChar : plaintext) {
        if (isalpha(pChar)) {
            int pVal = charToInt(pChar);
            int kVal = charToInt(key[keyIndex % key.length()]);
            int cVal = (pVal + kVal) % 26;
            ciphertext += intToChar(cVal, pChar);
            keyIndex++;
        } else {
            ciphertext += pChar;
        }
    }
    return ciphertext;
}

/**
 * @brief 对给定的文本进行维吉尼亚解密
 * @param ciphertext 要解密的密文
 * @param key 密钥
 * @return 解密后的明文
 */
std::string vigenereDecrypt(const std::string& ciphertext, const std::string& key) {
    std::string plaintext = "";
    int keyIndex = 0;
    for (char cChar : ciphertext) {
        if (isalpha(cChar)) {
            int cVal = charToInt(cChar);
            int kVal = charToInt(key[keyIndex % key.length()]);
            int pVal = (cVal - kVal + 26) % 26; // Add 26 to handle negative results of modulo
            plaintext += intToChar(pVal, cChar);
            keyIndex++;
        } else {
            plaintext += cChar;
        }
    }
    return plaintext;
}
```