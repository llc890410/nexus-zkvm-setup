#!/bin/bash

# 安裝 CMake
sudo apt update
sudo apt install -y cmake

# 安裝 Build Essential
sudo apt install -y build-essential

# 安裝 Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# 添加 RISC-V 目標
rustup target add riscv32i-unknown-none-elf

# 安裝 Nexus zkVM
cargo install --git https://github.com/nexus-xyz/nexus-zkvm nexus-tools --tag 'v1.0.0'

# 驗證安裝
cargo nexus --help

# 創建新項目
cargo nexus new nexus-project

# 移動到項目目錄
cd nexus-project/src

# 定義多個不同的main.rs內容
main_rs_contents=(
'#![no_std]
#![no_main]

fn fib(n: u32) -> u32 {
    match n {
        0 => 0,
        1 => 1,
        _ => fib(n - 1) + fib(n - 2),
    }
}

#[nexus_rt::main]
fn main() {
    let n = 7;
    let result = fib(n);
    assert_eq!(result, 13);
}
'
'#![no_std]
#![no_main]

fn sum(a: u32, b: u32) -> u32 {
    a + b
}

#[nexus_rt::main]
fn main() {
    let a = 3;
    let b = 4;
    let result = sum(a, b);
    assert_eq!(result, 7);
}
'
'#![no_std]
#![no_main]

fn factorial(n: u32) -> u32 {
    match n {
        0 => 1,
        _ => n * factorial(n - 1),
    }
}

#[nexus_rt::main]
fn main() {
    let n = 5;
    let result = factorial(n);
    assert_eq!(result, 120);
}
'
'#![no_std]
#![no_main]

fn square(n: u32) -> u32 {
    n * n
}

#[nexus_rt::main]
fn main() {
    let n = 6;
    let result = square(n);
    assert_eq!(result, 36);
}
'
'#![no_std]
#![no_main]

fn power(base: u32, exp: u32) -> u32 {
    if exp == 0 {
        1
    } else {
        base * power(base, exp - 1)
    }
}

#[nexus_rt::main]
fn main() {
    let base = 2;
    let exp = 3;
    let result = power(base, exp);
    assert_eq!(result, 8);
}
'
'#![no_std]
#![no_main]

fn gcd(a: u32, b: u32) -> u32 {
    if b == 0 {
        a
    } else {
        gcd(b, a % b)
    }
}

#[nexus_rt::main]
fn main() {
    let a = 48;
    let b = 18;
    let result = gcd(a, b);
    assert_eq!(result, 6);
}
'
'#![no_std]
#![no_main]

fn lcm(a: u32, b: u32) -> u32 {
    (a * b) / gcd(a, b)
}

fn gcd(a: u32, b: u32) -> u32 {
    if b == 0 {
        a
    } else {
        gcd(b, a % b)
    }
}

#[nexus_rt::main]
fn main() {
    let a = 12;
    let b = 15;
    let result = lcm(a, b);
    assert_eq!(result, 60);
}
'
'#![no_std]
#![no_main]

fn abs_diff(a: i32, b: i32) -> i32 {
    if a > b {
        a - b
    } else {
        b - a
    }
}

#[nexus_rt::main]
fn main() {
    let a = 7;
    let b = 10;
    let result = abs_diff(a, b);
    assert_eq!(result, 3);
}
'
'#![no_std]
#![no_main]

fn is_even(n: u32) -> bool {
    n % 2 == 0
}

#[nexus_rt::main]
fn main() {
    let n = 4;
    let result = is_even(n);
    assert!(result);
}
'
'#![no_std]
#![no_main]

fn is_prime(n: u32) -> bool {
    if n <= 1 {
        return false;
    }
    for i in 2..n {
        if n % i == 0 {
            return false;
        }
    }
    true
}

#[nexus_rt::main]
fn main() {
    let n = 5;
    let result = is_prime(n);
    assert!(result);
}
'
'#![no_std]
#![no_main]

fn reverse_array(arr: &mut [i32]) {
    arr.reverse();
}

#[nexus_rt::main]
fn main() {
    let mut arr = [1, 2, 3, 4, 5];
    reverse_array(&mut arr);
    assert_eq!(arr, [5, 4, 3, 2, 1]);
}
'
)

# 隨機選擇一個main.rs內容
selected_main_rs="${main_rs_contents[$RANDOM % ${#main_rs_contents[@]}]}"

# 寫入main.rs文件
echo "$selected_main_rs" > main.rs

# 返回到項目根目錄
cd ..

# 運行程序
cargo nexus run

# 打印完整步驟執行跟蹤
cargo nexus run -v

# 生成證明
cargo nexus prove

# 驗證證明
cargo nexus verify

# 保存證明
mkdir -p nexus-proof-directory
mv nexus-proof nexus-proof-directory/

echo "Nexus zkVM 安裝和配置完成。證明已保存到 nexus-proof-directory 目錄中。"
