+++
title = '波利比奥斯方阵密码'
description = '本篇文章主要分享古典密码学的波利比奥斯方阵密码'
tags = ['古典密码学', 'C++']
keywords = ['古典密码学', '波利比奥斯方阵密码', '加密算法', 'C++']
date = 2025-08-14T17:34:00+08:00
categories = ['古典密码']
+++

## 什么是波利比奥斯方阵密码？

波利比奥斯方阵密码（Polybius Square Cipher），又称棋盘密码，是一种**替换密码（Substitution Cipher）**，由古希腊历史学家波利比奥斯（Polybius）在公元前2世纪发明。它将字母映射到数字对，从而实现加密。这种密码最初是为了通过火炬信号进行远距离通信而设计的，每个字母通过其在方阵中的坐标来表示。

波利比奥斯方阵通常是一个5x5的网格，包含了25个英文字母。由于英文字母有26个，通常会将字母 `I` 和 `J` 合并处理，或者将 `K` 替换为 `C` 等，以适应25个格子的限制。每个字母由其所在的行号和列号组成的数字对来表示。

**波利比奥斯方阵示例 (5x5):**

|   | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| 1 | A | B | C | D | E |
| 2 | F | G | H | I/J | K |
| 3 | L | M | N | O | P |
| 4 | Q | R | S | T | U |
| 5 | V | W | X | Y | Z |

**加密过程：**

1.  **构建方阵：** 确定一个5x5的方阵，将字母填入其中。通常 `I` 和 `J` 共用一个格子。
2.  **明文转换：** 将明文中的每个字母替换为其在方阵中的坐标对。坐标通常是先行后列。

例如，如果明文是 `HELLO`：
- `H` 在第2行第3列，表示为 `23`。
- `E` 在第1行第5列，表示为 `15`。
- `L` 在第3行第1列，表示为 `31`。
- `L` 在第3行第1列，表示为 `31`。
- `O` 在第3行第4列，表示为 `34`。

**加密示例:**
- **明文 (Plaintext):** `HELLO`
- **密文 (Ciphertext):** `2315313134`

## 波利比奥斯方阵密码的数学表示

波利比奥斯方阵密码的数学表示相对简单，它主要涉及将字母映射到二维坐标，然后将这些坐标串联起来。虽然没有像凯撒密码或维吉尼亚密码那样直接的模运算公式，但其核心是基于查表和坐标转换。

设：
- 字母表 `Σ = {A, B, ..., Z}`
- 方阵 `M` 是一个 5x5 的矩阵，其中 `M[row][col]` 存储一个字母。
- `char_to_coords(c)` 函数返回字母 `c` 在方阵 `M` 中的坐标 `(row, col)`。
- `coords_to_char(row, col)` 函数返回坐标 `(row, col)` 在方阵 `M` 中对应的字母。

**加密过程：**

对于明文中的每个字母 `P_i`：
1.  找到 `P_i` 在方阵 `M` 中的坐标 `(row_i, col_i)`。
2.  将 `row_i` 和 `col_i` 转换为字符串形式，并连接起来形成密文的一部分。

**解密过程：**

对于密文中的每对数字 `(d1, d2)`：
1.  将 `d1` 解释为行号 `row`，`d2` 解释为列号 `col`。
2.  找到方阵 `M` 中 `M[row][col]` 对应的字母 `P_i`。

**示例方阵 (5x5，I/J合并):**

|   | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| 1 | A | B | C | D | E |
| 2 | F | G | H | I/J | K |
| 3 | L | M | N | O | P |
| 4 | Q | R | S | T | U |
| 5 | V | W | X | Y | Z |

**加密函数 (伪代码):**

```
function encrypt(plaintext):
    ciphertext = ""
    for each char P in plaintext:
        if P is an alphabet letter:
            if P == 'J': P = 'I' // Handle I/J merge
            (row, col) = char_to_coords(P)
            ciphertext += to_string(row) + to_string(col)
        else:
            ciphertext += P // Non-alphabet characters remain unchanged
    return ciphertext
```

**解密函数 (伪代码):**

```
function decrypt(ciphertext):
    plaintext = ""
    for i from 0 to length(ciphertext) - 1 step 2:
        d1 = to_int(ciphertext[i])
        d2 = to_int(ciphertext[i+1])
        P = coords_to_char(d1, d2)
        plaintext += P
    return plaintext
```

这种密码的数学表示更侧重于查找表和索引操作，而不是复杂的算术运算。

## 如何破解波利比奥斯方阵密码？

波利比奥斯方阵密码虽然将字母转换成了数字对，但它仍然是一种单表替换密码。这意味着每个明文字母总是被相同的数字对替换。因此，它和凯撒密码一样，容易受到频率分析的攻击。

### 1. 频率分析 (Frequency Analysis)

这是破解波利比奥斯方阵密码最主要的方法。攻击者可以统计密文中每个数字对的出现频率，并将其与已知语言（例如英语）中字母的频率分布进行比较。例如，在英语中，字母 `E` 的出现频率最高，那么密文中出现频率最高的数字对很可能就代表 `E`。一旦确定了几个这样的对应关系，就可以逐步推断出整个方阵的映射关系，从而解密密文。

**破解步骤：**

1.  **统计密文频率：** 将密文中的数字对（例如，`23`, `15` 等）进行统计，找出出现频率最高的数字对。
2.  **匹配语言频率：** 将这些高频数字对与目标语言（如英语）中高频字母（如 `E`, `T`, `A`, `O`, `I`, `N` 等）进行匹配。
3.  **重建方阵：** 根据推断出的映射关系，逐步重建波利比奥斯方阵。
4.  **解密：** 使用重建的方阵来解密整个密文。

### 2. 暴力破解 (Brute-force Attack)

虽然不如频率分析高效，但理论上也可以通过暴力破解来尝试所有可能的方阵排列。然而，由于方阵的排列组合数量巨大，这种方法在实践中是不可行的。

### 3. 已知明文攻击 (Known-plaintext Attack)

如果攻击者拥有一些明文和对应的密文对，那么破解将变得非常容易。通过比较明文和密文，可以直接推导出方阵的映射关系。

### 4. 字典攻击 (Dictionary Attack)

如果密文是短语或单词，攻击者可以尝试使用常见的单词或短语进行加密，然后与密文进行比较，以找到匹配项。

总的来说，波利比奥斯方阵密码的安全性非常低，不适用于保护敏感信息。它主要作为密码学教学中的一个早期示例，展示了将字母转换为数字表示的初步尝试。

## C++ 代码实现

下面是一个简单的 C++ 程序，它实现了波利比奥斯方阵密码的加密和解密功能。代码结构清晰，并包含了详细的注释。

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <cctype>
#include <map>

// Define the Polybius Square (5x5, I/J combined)
const char polybiusSquare[5][5] = {
    {'A', 'B', 'C', 'D', 'E'},
    {'F', 'G', 'H', 'I', 'K'}, // I/J combined
    {'L', 'M', 'N', 'O', 'P'},
    {'Q', 'R', 'S', 'T', 'U'},
    {'V', 'W', 'X', 'Y', 'Z'}
};

// Map to store character to coordinates for encryption
std::map<char, std::pair<int, int>> charToCoords;

// Function to initialize the charToCoords map
void initializeMap() {
    for (int i = 0; i < 5; ++i) {
        for (int j = 0; j < 5; ++j) {
            charToCoords[polybiusSquare[i][j]] = {i + 1, j + 1}; // 1-indexed
        }
    }
    charToCoords["J"] = charToCoords["I"]; // Handle J as I
}

std::string polybiusEncrypt(const std::string& plaintext);
std::string polybiusDecrypt(const std::string& ciphertext);

int main() {
    initializeMap(); // Initialize the map once

    std::string message;

    std::cout << "=====================================" << std::endl;
    std::cout << "      波利比奥斯方阵密码加密/解密程序" << std::endl;
    std::cout << "=====================================" << std::endl;

    std::cout << "\n请输入要处理的消息 (只包含字母): ";
    std::getline(std::cin, message);

    std::string encryptedMessage = polybiusEncrypt(message);
    std::cout << "\n加密后的密文是: " << encryptedMessage << std::endl;

    std::string decryptedMessage = polybiusDecrypt(encryptedMessage);
    std::cout << "解密后的明文是: " << decryptedMessage << std::endl;

    return 0;
}

/**
 * @brief 对给定的文本进行波利比奥斯方阵加密
 * @param plaintext 要加密的明文
 * @return 加密后的密文 (数字串)
 */
std::string polybiusEncrypt(const std::string& plaintext) {
    std::string ciphertext = "";
    for (char pChar : plaintext) {
        pChar = toupper(pChar); // Convert to uppercase for consistency
        if (isalpha(pChar)) {
            if (pChar == 'J') pChar = 'I'; // Handle J as I
            if (charToCoords.count(pChar)) {
                ciphertext += std::to_string(charToCoords[pChar].first);
                ciphertext += std::to_string(charToCoords[pChar].second);
            }
        } else {
            ciphertext += pChar; // Non-alphabet characters remain unchanged
        }
    }
    return ciphertext;
}

/**
 * @brief 对给定的密文进行波利比奥斯方阵解密
 * @param ciphertext 要解密的密文 (数字串)
 * @return 解密后的明文
 */
std::string polybiusDecrypt(const std::string& ciphertext) {
    std::string plaintext = "";
    for (size_t i = 0; i < ciphertext.length(); i += 2) {
        if (isdigit(ciphertext[i]) && isdigit(ciphertext[i+1])) {
            int row = ciphertext[i] - '0';
            int col = ciphertext[i+1] - '0';
            if (row >= 1 && row <= 5 && col >= 1 && col <= 5) {
                plaintext += polybiusSquare[row - 1][col - 1]; // Convert back to 0-indexed
            }
        } else {
            // Handle non-digit characters (e.g., spaces) that were not encrypted
            plaintext += ciphertext[i];
            if (i + 1 < ciphertext.length()) {
                plaintext += ciphertext[i+1];
            }
            i -= 1; // Adjust index for single non-digit char or pair
        }
    }
    return plaintext;
}
```