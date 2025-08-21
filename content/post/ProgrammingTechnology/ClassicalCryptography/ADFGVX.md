+++
title = 'ADFGVX密码'
description = '本篇文章主要分享古典密码学的ADFGVX密码'
tags = ['古典密码学', 'C++']
keywords = ['古典密码学', 'ADFGVX密码', '加密算法', 'C++']
date = 2025-08-21T17:37:00+08:00
categories = ['古典密码']
+++

## 什么是ADFGVX密码？

ADFGVX密码是一种在第一次世界大战期间由德国陆军使用的**分段密码（Fractionating Cipher）**，它结合了**替换（Substitution）**和**换位（Transposition）**两种加密方式。这种密码由德国军官弗里茨·内贝尔（Fritz Nebel）于1918年发明，最初的版本是ADFGX密码，后来为了增加数字的加密能力，加入了字母V，演变为ADFGVX密码。

ADFGVX密码的名称来源于其密文使用的六个字母：A、D、F、G、V、X。选择这些字母是为了避免在摩尔斯电码传输时出现混淆，因为它们的摩尔斯电码差异较大。

这种密码的复杂性远超之前的凯撒密码、维吉尼亚密码等，因为它引入了多阶段加密，使得频率分析等传统破解方法变得更加困难。它在战争中被用于传输重要的军事信息，直到法国密码分析师乔治·潘文（Georges Painvin）成功将其破解。

**ADFGVX密码的工作原理主要分为两个阶段：**

1.  **替换阶段（Substitution）：** 使用一个5x5（对于ADFGX）或6x6（对于ADFGVX）的波利比奥斯方阵（Polybius Square）将明文中的每个字符替换为一对ADFGVX字母。这个方阵是根据一个密钥单词随机填充的。
2.  **换位阶段（Transposition）：** 将替换后的密文（现在是一串ADFGVX字母）写入一个矩阵中，然后根据另一个密钥单词的字母顺序对列进行重新排列，从而实现换位加密。

这两个阶段的结合使得ADFGVX密码在当时具有相当高的安全性。

## ADFGVX密码的工作原理

ADFGVX密码的加密过程分为两个主要步骤：**分段替换**和**列换位**。

### 1. 分段替换（Substitution）

这一阶段使用一个6x6的方阵，其中包含26个英文字母和10个数字（0-9）。这个方阵的填充顺序是根据一个密钥单词（例如 `PHRASE`）来确定的，首先填入密钥单词中不重复的字母，然后按字母表顺序填入剩余的字母和数字。方阵的行和列都用ADFGVX这六个字母标记。

**示例方阵 (密钥 `PHRASE`):**

|   | A | D | F | G | V | X |
|---|---|---|---|---|---|---|
| A | P | H | R | A | S | E |
| D | B | C | D | F | G | I |
| F | J | K | L | M | N | O |
| G | Q | T | U | V | W | X |
| V | Y | Z | 0 | 1 | 2 | 3 |
| X | 4 | 5 | 6 | 7 | 8 | 9 |

**替换步骤：**

1.  **明文标准化：** 将明文中的所有字母转换为大写，并移除所有非字母数字字符。
2.  **查找替换：** 将明文中的每个字符替换为其在方阵中的坐标。坐标由行标签和列标签组成。例如，如果明文是 `ATTACK`：
    - `A` 在方阵中位于 `AG`。
    - `T` 在方阵中位于 `GD`。
    - `T` 在方阵中位于 `GD`。
    - `A` 在方阵中位于 `AG`。
    - `C` 在方阵中位于 `DC`。
    - `K` 在方阵中位于 `DI`。

    替换后的结果是：`AGGDGDAGDCDI`。

### 2. 列换位（Transposition）

这一阶段使用另一个密钥单词（例如 `GERMAN`）进行列换位。替换阶段生成的密文（一串ADFGVX字母）被写入一个矩阵中，矩阵的列数等于换位密钥的长度。然后，根据换位密钥字母的字母顺序对矩阵的列进行重新排列。

**换位步骤：**

1.  **构建矩阵：** 将替换阶段生成的密文逐行填入一个矩阵中，矩阵的列数等于换位密钥的长度。
    例如，替换后的密文 `AGGDGDAGDCDI`，换位密钥 `GERMAN` (长度为6)。

    | G | E | R | M | A | N |
    |---|---|---|---|---|---|
    | A | G | G | D | G | D |
    | A | G | D | C | D | I |

2.  **列排序：** 根据换位密钥字母的字母顺序对列进行排序。`GERMAN` 排序后是 `AEGMNR`。

    原始列顺序：
    G (AG) E (GD) R (GD) M (AG) A (DC) N (DI)

    排序后的列顺序：
    A (DC) E (GD) G (AG) M (AG) N (DI) R (GD)

3.  **读取密文：** 按照排序后的列顺序，从上到下逐列读取矩阵中的字母，形成最终的密文。

    最终密文：`DCA GGD AG AGD IDG` (通常会去除空格)

**综合加密示例:**

-   **明文 (Plaintext):** `ATTACK`
-   **替换方阵密钥 (Substitution Key):** `PHRASE`
-   **换位密钥 (Transposition Key):** `GERMAN`

1.  **替换阶段：**
    `ATTACK` -> `AGGDGDAGDCDI`

2.  **换位阶段：**
    将 `AGGDGDAGDCDI` 填入以 `GERMAN` 为列头的矩阵：

    | G | E | R | M | A | N |
    |---|---|---|---|---|---|
    | A | G | G | D | G | D |
    | A | G | D | C | D | I |

    按字母顺序排序 `GERMAN` -> `AEGMNR`，并重新排列列：

    | A | E | G | M | N | R |
    |---|---|---|---|---|---|
    | G | G | A | D | D | G |
    | D | G | A | C | I | D |

    从上到下逐列读取：`GD GG AA DC DI GD`

-   **最终密文 (Ciphertext):** `GDGG AADC DIDG` (通常为了传输方便，会分成5个一组)

解密过程则是加密的逆过程，首先进行列逆换位，然后进行分段逆替换。

## 如何破解ADFGVX密码？

ADFGVX密码在第一次世界大战期间被认为是相当安全的，因为它结合了替换和换位两种复杂的加密机制，使得传统的频率分析方法难以直接应用。然而，法国密码分析师乔治·潘文（Georges Painvin）在1918年成功破解了这种密码，这被认为是密码学史上的一个重大突破。

破解ADFGVX密码的关键在于其两阶段的加密过程，需要分别攻击替换和换位。

### 1. 攻击换位阶段：确定换位密钥长度

破解的第一步是确定换位密钥的长度。潘文的方法主要依赖于**频率分析**和**重合指数法**，但需要更复杂的应用。

-   **重合指数法（Index of Coincidence, IC）：**
    尽管ADFGVX密码经过替换和换位，但如果能正确地猜测换位密钥的长度，将密文重新排列成原始的列，那么每一列的字母仍然是经过波利比奥斯方阵替换后的结果。通过计算不同假设密钥长度下，重新排列后的列的重合指数，可以寻找接近随机文本重合指数（对于ADFGVX字母表，其重合指数会与26个字母的有所不同，但仍然可以作为判断依据）的模式。当重合指数出现显著变化时，可能就找到了正确的密钥长度。

-   **统计分析：**
    潘文利用了德语中字母频率的统计特性。虽然ADFGVX密文看起来是随机的，但如果能正确地将密文分解成原始的列，那么这些列的统计特性会反映出德语的某些特征。通过分析密文中重复出现的模式和它们的间距，可以推测换位密钥的长度。

### 2. 攻击替换阶段：确定波利比奥斯方阵和替换密钥

一旦换位密钥的长度被确定，密文就可以被重新排列成原始的列。此时，每一列的字母实际上是经过波利比奥斯方阵替换后的结果。由于波利比奥斯方阵是固定的，因此可以对这些列进行**频率分析**来推断出原始的波利比奥斯方阵和替换密钥。

-   **频率分析：**
    尽管波利比奥斯方阵将一个字母替换为两个ADFGVX字母，但每个明文字母的出现频率仍然会影响到其对应的ADFGVX对的频率。通过分析这些ADFGVX对的频率，并与德语中字母和数字的频率进行比较，可以逐步推断出方阵中每个位置对应的字符。

-   **已知明文攻击：**
    如果攻击者能够获得一些明文和对应的密文对，那么破解难度将大大降低。通过比较明文和密文，可以直接推导出波利比奥斯方阵的映射关系和换位密钥。

### 3. 组合密钥并解密

当替换密钥（波利比奥斯方阵的布局）和换位密钥都被确定后，就可以对密文进行逆向操作，首先进行逆换位，然后进行逆替换，从而恢复明文。

ADFGVX密码的破解是密码学发展史上的一个里程碑，它展示了即使是复杂的组合密码，在足够的数据和巧妙的分析方法面前，也并非不可攻破。潘文的成功不仅对第一次世界大战的进程产生了影响，也为后来的密码分析技术奠定了基础。

## C++ 代码实现

ADFGVX密码的C++实现相对复杂，因为它涉及两个阶段：替换和换位。下面是一个简化的C++程序，演示了ADFGVX密码的加密和解密过程。为了简化，这里将使用一个固定的波利比奥斯方阵，并假设明文只包含大写字母和数字。

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <algorithm>
#include <cctype>

// ADFGVX字母表
const std::string ADFGVX_CHARS = "ADFGVX";

// 固定的波利比奥斯方阵 (6x6)
// 包含26个字母和10个数字
const char POLYBIUS_SQUARE[6][6] = {
    {'P', 'H', 'R', 'A', 'S', 'E'},
    {'B', 'C', 'D', 'F', 'G', 'I'},
    {'J', 'K', 'L', 'M', 'N', 'O'},
    {'Q', 'T', 'U', 'V', 'W', 'X'},
    {'Y', 'Z', '0', '1', '2', '3'},
    {'4', '5', '6', '7', '8', '9'}
};

// 用于快速查找字符坐标的映射
std::map<char, std::pair<int, int>> charToCoords;

// 初始化字符到坐标的映射
void initializeCharToCoords() {
    for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < 6; ++j) {
            charToCoords[POLYBIUS_SQUARE[i][j]] = {i, j};
        }
    }
}

// 将明文替换为ADFGVX坐标对
std::string substitute(const std::string& plaintext) {
    std::string substitutedText = "";
    for (char c : plaintext) {
        c = toupper(c); // 转换为大写
        if (charToCoords.count(c)) {
            substitutedText += ADFGVX_CHARS[charToCoords[c].first];
            substitutedText += ADFGVX_CHARS[charToCoords[c].second];
        } else if (isdigit(c)) { // 处理数字
            // 查找数字在方阵中的位置
            bool found = false;
            for (int i = 0; i < 6; ++i) {
                for (int j = 0; j < 6; ++j) {
                    if (POLYBIUS_SQUARE[i][j] == c) {
                        substitutedText += ADFGVX_CHARS[i];
                        substitutedText += ADFGVX_CHARS[j];
                        found = true;
                        break;
                    }
                }
                if (found) break;
            }
        } else {
            // 忽略非字母数字字符
        }
    }
    return substitutedText;
}

// 根据换位密钥进行列换位加密
std::string transposeEncrypt(const std::string& substitutedText, const std::string& key) {
    std::string cleanKey = "";
    for (char c : key) {
        if (isalpha(c)) {
            cleanKey += toupper(c);
        }
    }

    int keyLength = cleanKey.length();
    if (keyLength == 0) return substitutedText; // No transposition if key is empty

    int numRows = (substitutedText.length() + keyLength - 1) / keyLength;
    std::vector<std::vector<char>> grid(numRows, std::vector<char>(keyLength, ' '));

    int textIndex = 0;
    for (int r = 0; r < numRows; ++r) {
        for (int c = 0; c < keyLength; ++c) {
            if (textIndex < substitutedText.length()) {
                grid[r][c] = substitutedText[textIndex++];
            }
        }
    }

    // 创建密钥索引对，用于排序
    std::vector<std::pair<char, int>> keyOrder(keyLength);
    for (int i = 0; i < keyLength; ++i) {
        keyOrder[i] = {cleanKey[i], i};
    }
    std::sort(keyOrder.begin(), keyOrder.end());

    std::string ciphertext = "";
    for (int i = 0; i < keyLength; ++i) {
        int originalCol = keyOrder[i].second;
        for (int r = 0; r < numRows; ++r) {
            if (grid[r][originalCol] != ' ') {
                ciphertext += grid[r][originalCol];
            }
        }
    }
    return ciphertext;
}

// 根据换位密钥进行列逆换位解密
std::string transposeDecrypt(const std::string& ciphertext, const std::string& key) {
    std::string cleanKey = "";
    for (char c : key) {
        if (isalpha(c)) {
            cleanKey += toupper(c);
        }
    }

    int keyLength = cleanKey.length();
    if (keyLength == 0) return ciphertext; // No transposition if key is empty

    int numRows = (ciphertext.length() + keyLength - 1) / keyLength;
    std::vector<std::vector<char>> grid(numRows, std::vector<char>(keyLength, ' '));

    // 计算每列的长度
    std::vector<int> colLengths(keyLength);
    int remaining = ciphertext.length();
    for (int i = 0; i < keyLength; ++i) {
        colLengths[i] = numRows;
        if (remaining % keyLength != 0 && i >= (keyLength - (numRows * keyLength - ciphertext.length()))) {
            colLengths[i]--; // 最后一行的空位
        }
        remaining -= colLengths[i];
    }

    // 重新构建密钥索引对，用于排序
    std::vector<std::pair<char, int>> keyOrder(keyLength);
    for (int i = 0; i < keyLength; ++i) {
        keyOrder[i] = {cleanKey[i], i};
    }
    std::sort(keyOrder.begin(), keyOrder.end());

    // 填充网格
    int currentCipherIndex = 0;
    for (int i = 0; i < keyLength; ++i) {
        int originalCol = keyOrder[i].second;
        for (int r = 0; r < colLengths[originalCol]; ++r) {
            grid[r][originalCol] = ciphertext[currentCipherIndex++];
        }
    }

    std::string substitutedText = "";
    for (int r = 0; r < numRows; ++r) {
        for (int c = 0; c < keyLength; ++c) {
            if (grid[r][c] != ' ') {
                substitutedText += grid[r][c];
            }
        }
    }
    return substitutedText;
}

// 将ADFGVX坐标对逆替换回明文
std::string substituteDecrypt(const std::string& substitutedText) {
    std::string plaintext = "";
    for (size_t i = 0; i < substitutedText.length(); i += 2) {
        char rowChar = substitutedText[i];
        char colChar = substitutedText[i+1];

        int row = ADFGVX_CHARS.find(rowChar);
        int col = ADFGVX_CHARS.find(colChar);

        if (row != std::string::npos && col != std::string::npos) {
            plaintext += POLYBIUS_SQUARE[row][col];
        }
    }
    return plaintext;
}

int main() {
    initializeCharToCoords(); // 初始化映射

    std::string plaintext;
    std::string transpositionKey;

    std::cout << "=====================================" << std::endl;
    std::cout << "        ADFGVX密码加密/解密程序" << std::endl;
    std::cout << "=====================================" << std::endl;

    std::cout << "\n请输入要加密的消息 (只包含字母和数字): ";
    std::getline(std::cin, plaintext);

    std::cout << "请输入换位密钥 (只包含字母): ";
    std::getline(std::cin, transpositionKey);

    // 加密过程
    std::string substituted = substitute(plaintext);
    std::string encrypted = transposeEncrypt(substituted, transpositionKey);
    std::cout << "\n加密后的密文是: " << encrypted << std::endl;

    // 解密过程
    std::string decryptedSubstituted = transposeDecrypt(encrypted, transpositionKey);
    std::string decryptedPlaintext = substituteDecrypt(decryptedSubstituted);
    std::cout << "解密后的明文是: " << decryptedPlaintext << std::endl;

    return 0;
}
```