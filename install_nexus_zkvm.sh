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

# 修改 main.rs 文件
cat <<EOL > main.rs
#![no_std]
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
EOL

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
