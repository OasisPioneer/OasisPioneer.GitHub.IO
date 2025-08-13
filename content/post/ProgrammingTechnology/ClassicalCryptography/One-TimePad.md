+++
title = '一次性密码本'
description = '本篇文章主要分享古典密码学中理论上绝对安全的一次性密码本'
tags = ['古典密码学', 'C++']
keywords = ['古典密码学', '一次性密码本', '加密算法', 'C++']
date = 2025-08-13T23:41:29+08:00
categories = ['编程技术']
+++

## 什么是一次性密码本？

一次性密码本（One-Time Pad, OTP），又称“一次一密”，是古典密码学中一种理论上被证明**绝对安全**的加密算法。它由美国电话电报公司的吉尔伯特·维纳姆（Gilbert Vernam）于1917年发明，并由克劳德·香农（Claude Shannon）在信息论中证明了其不可破译性。

一次性密码本的核心思想是使用一个**与明文等长、完全随机且只使用一次的密钥**。加密过程是将明文与密钥进行逐位（或逐字符）的异或（XOR）运算。由于密钥的随机性、等长性和一次性，即使攻击者截获了密文，也无法从中获取任何关于明文的信息。

**一次性密码本的三个核心条件：**

1.  **密钥必须是真正随机的：** 密钥的生成必须是完全不可预测的，不能有任何模式或可重复性。
2.  **密钥必须与明文等长：** 密钥的长度必须至少与要加密的明文长度相同。
3.  **密钥必须只使用一次：** 每个密钥只能用于加密一条消息，之后必须立即销毁，不能重复使用。

如果这三个条件都得到满足，那么一次性密码本是唯一一种被数学证明为绝对安全的加密方案。任何密文都可能对应任何明文，因为存在一个密钥可以将密文转换为任何可能的明文，这使得攻击者无法区分真实的明文。

**加密示例 (以字母为例，A=0, B=1, ..., Z=25):**

假设明文为 `HELLO`，密钥为 `XMCKL`。

| 明文 (P) | H (7) | E (4) | L (11) | L (11) | O (14) |
|---|---|---|---|---|---|
| 密钥 (K) | X (23) | M (12) | C (2) | K (10) | L (11) |
| 加密 (P+K mod 26) | (7+23)%26=4 (E) | (4+12)%26=16 (Q) | (11+2)%26=13 (N) | (11+10)%26=21 (V) | (14+11)%26=25 (Z) |
| 密文 (C) | E | Q | N | V | Z |

- **明文 (Plaintext):** `HELLO`
- **密钥 (Key):** `XMCKL`
- **密文 (Ciphertext):** `EQNVZ`

## 一次性密码本的数学表示

一次性密码本的数学表示通常使用异或（XOR）运算，尤其是在二进制层面。如果我们将明文和密钥都视为二进制序列，那么加密和解密过程可以表示为：

设：
- `P` 为明文（二进制序列）。
- `K` 为密钥（二进制序列）。
- `C` 为密文（二进制序列）。

那么，加密过程可以表示为：
$$ C = P \oplus K $$

解密过程则是：
$$ P = C \oplus K $$

其中 `$\oplus$` 表示异或运算。异或运算的特性是 `A \oplus B \oplus B = A`，这使得加密和解密可以使用相同的操作。当明文和密钥都是字母时，我们可以将它们转换为数字（例如，A=0, B=1, ..., Z=25），然后进行模加运算，这与异或运算在概念上是相似的。

设：
- `P_i` 为明文的第 `i` 个字母对应的数字。
- `K_i` 为密钥的第 `i` 个字母对应的数字。
- `C_i` 为密文的第 `i` 个字母对应的数字。

那么，加密过程可以表示为：
$$ C_i = (P_i + K_i) \pmod{26} $$

解密过程则是：
$$ P_i = (C_i - K_i + 26) \pmod{26} $$

这里的 `mod 26` (模26) 运算确保了结果在 0 到 25 之间，并且处理了负数的情况。

## 一次性密码本为何不可破译？

一次性密码本之所以被认为是理论上绝对安全的，其核心在于满足了香农的**完美保密性（Perfect Secrecy）**定义。完美保密性意味着，给定密文，攻击者无法获得任何关于明文的信息，即密文不泄露任何明文信息。

具体来说，一次性密码本的不可破译性基于以下几点：

1.  **密钥的完全随机性：** 密钥是真正随机生成的，这意味着密钥中的每一个位（或字符）都是独立且均匀分布的。攻击者无法通过任何统计方法或模式分析来预测密钥的下一个部分。

2.  **密钥与明文等长：** 密钥的长度与明文完全相同。这保证了密钥的每一个部分都只用于加密明文的对应部分，没有重复使用。

3.  **密钥的一次性使用：** 密钥只使用一次。这是最关键的条件。如果密钥被重复使用，即使是随机生成的，也会引入可分析的模式，从而导致密码被破解（例如，通过异或两个使用相同密钥加密的密文，可以得到两个明文的异或结果，从而进行频率分析）。

4.  **密文的均匀分布：** 当密钥是完全随机且与明文等长时，生成的密文也是完全随机且均匀分布的。这意味着，对于任何给定的密文，所有可能的明文都以相同的概率对应这个密文。攻击者无法通过分析密文的统计特性来推断出原始明文的任何信息。

举例来说，如果密文是 `X`，攻击者不知道明文是 `A` 还是 `B`。如果明文是 `A`，那么密钥必须是 `K_A` 才能生成 `X`；如果明文是 `B`，那么密钥必须是 `K_B` 才能生成 `X`。由于密钥是完全随机的，`K_A` 和 `K_B` 都是同样可能的密钥。因此，攻击者无法区分明文是 `A` 还是 `B`，因为两种情况都同样符合逻辑。

正是由于这些严格的条件，一次性密码本在理论上提供了无条件的安全。然而，在实际应用中，生成、分发和管理真正随机且只使用一次的等长密钥是非常困难和昂贵的，这限制了其大规模应用。它主要用于高度机密的通信，例如外交和军事领域。

## C++ 代码实现

下面是一个简单的 C++ 程序，它演示了一次性密码本的加密和解密功能。请注意，在实际应用中，密钥的生成和管理会更加复杂，以确保其真正的随机性和一次性。

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <cctype>
#include <random>
#include <chrono>

// Function to generate a random key of a given length
std::string generateRandomKey(int length) {
    std::string key = "";
    // Use a random device to seed the random number generator
    std::random_device rd;
    // Use the Mersenne Twister engine
    std::mt19937 gen(rd());
    // Define a distribution for characters (e.g., 'A' to 'Z')
    std::uniform_int_distribution<> distrib(0, 25); // 0-25 for A-Z

    for (int i = 0; i < length; ++i) {
        key += static_cast<char>("ABCDEFGHIJKLMNOPQRSTUVWXYZ"[distrib(gen)]);
    }
    return key;
}

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

std::string oneTimePadEncrypt(const std::string& plaintext, const std::string& key);
std::string oneTimePadDecrypt(const std::string& ciphertext, const std::string& key);

int main() {
    std::string message;
    std::string key;

    std::cout << "=====================================" << std::endl;
    std::cout << "      一次性密码本加密/解密程序" << std::endl;
    std::cout << "=====================================" << std::endl;

    std::cout << "\n请输入要处理的消息 (只包含字母): ";
    std::getline(std::cin, message);

    // Generate a random key of the same length as the message
    key = generateRandomKey(message.length());
    std::cout << "生成的密钥是: " << key << std::endl;

    std::string encryptedMessage = oneTimePadEncrypt(message, key);
    std::cout << "\n加密后的密文是: " << encryptedMessage << std::endl;

    std::string decryptedMessage = oneTimePadDecrypt(encryptedMessage, key);
    std::cout << "解密后的明文是: " << decryptedMessage << std::endl;

    return 0;
}

/**
 * @brief 对给定的文本进行一次性密码本加密
 * @param plaintext 要加密的明文
 * @param key 密钥 (与明文等长，完全随机)
 * @return 加密后的密文
 */
std::string oneTimePadEncrypt(const std::string& plaintext, const std::string& key) {
    std::string ciphertext = "";
    for (size_t i = 0; i < plaintext.length(); ++i) {
        if (isalpha(plaintext[i])) {
            int pVal = charToInt(plaintext[i]);
            int kVal = charToInt(key[i]);
            int cVal = (pVal + kVal) % 26;
            ciphertext += intToChar(cVal, plaintext[i]);
        } else {
            ciphertext += plaintext[i];
        }
    }
    return ciphertext;
}

/**
 * @brief 对给定的文本进行一次性密码本解密
 * @param ciphertext 要解密的密文
 * @param key 密钥 (与密文等长，完全随机)
 * @return 解密后的明文
 */
std::string oneTimePadDecrypt(const std::string& ciphertext, const std::string& key) {
    std::string plaintext = "";
    for (size_t i = 0; i < ciphertext.length(); ++i) {
        if (isalpha(ciphertext[i])) {
            int cVal = charToInt(ciphertext[i]);
            int kVal = charToInt(key[i]);
            int pVal = (cVal - kVal + 26) % 26; // Add 26 to handle negative results of modulo
            plaintext += intToChar(pVal, ciphertext[i]);
        } else {
            plaintext += ciphertext[i];
        }
    }
    return plaintext;
}
```