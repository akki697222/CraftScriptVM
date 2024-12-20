# CraftScript VM
## 命令セット
形式: `[オペコード(8bit)] [オペランド(54bit)]`

例:
```
0x01
0x02
; PUSH 2
0x02
0x00
; POP
```

## オペコード
### スタック操作
- `0x01 (0000 0001)` PUSH   # 特定の値をスタックの一番上に追加
- `0x02 (0000 0010)` POP    # スタックトップの値を削除
- `0x03 (0000 0011)` DUP    # スタックトップの値を複製
- `0x04 (0000 0100)` SWAP   # スタックの上位2つの要素を交換
- `0x05 (0000 0110)` PICK   # n番目の要素をコピー
- `0x06 (0000 0111)` ROLL   # n番目の要素をスタックトップに移動
### 算術演算
- `0x10 (0001 0000)` ADD    # スタックの上位2要素を加算
- `0x11 (0001 0001)` SUB    # スタックの上位2要素を減算
- `0x12 (0001 0010)` MUL    # スタックの上位2要素を乗算
- `0x13 (0001 0011)` DIV    # スタックの上位2要素を除算
- `0x14 (0001 0100)` MOD    # スタックの上位2要素の剰余
### 比較・分岐
- `0x20 (0010 0000)` CMP    # スタックの上位2要素を比較してフラグを設定
- `0x21 (0010 0001)` JMP    # 指定アドレスに無条件ジャンプ
- `0x22 (0010 0010)` JE     # 等しければジャンプ
- `0x23 (0010 0011)` JNE    # 等しくなければジャンプ
- `0x24 (0010 0100)` JL     # より小さければジャンプ
- `0x25 (0010 0101)` JG     # より大きければジャンプ
### メモリ操作
- `0x30 (0011 0000)` LOAD   # メモリから値を読み込み
- `0x31 (0011 0001)` STORE  # メモリに値を書き込み
### サブルーチン
- `0x40 (0100 0000)` CALL   # サブルーチンを呼び出し
- `0x41 (0100 0001)` RET    # サブルーチンから戻る
### オブジェクト操作
- `0x50 (0101 0000)` NEW    # 新しいオブジェクトを生成
- `0x51 (0101 0001)` DEL    # オブジェクトを削除
- `0x52 (0101 0010)` GETF   # オブジェクトのフィールドを取得
- `0x53 (0101 0011)` SETF   # オブジェクトのフィールドを設定
- `0x54 (0101 0100)` CALLM  # オブジェクトのメソッドを呼び出し
### 配列操作
- `0x60 (0110 0000)` NEWARRAY  # 新しい配列を生成
- `0x61 (0110 0001)` ARRLEN    # 配列の長さを取得
- `0x62 (0110 0010)` ALOAD     # 配列から要素を読み込み
- `0x63 (0110 0011)` ASTORE    # 配列に要素を書き込み
### 例外処理
- `0x70 (0111 0000)` THROW     # 例外をスロー
- `0x71 (0111 0001)` CATCH     # 例外をキャッチ
### 型
- `0x80 (1000 0000)` TYPEOF   # スタックトップの要素の型を取得
- `0x81 (1000 0001)` TYPESIZE # 指定型のサイズを取得
- `0x82 (1000 0010)` CAST     # スタックトップの値を指定型に変換
- `0x83 (1000 0011)` CONVERT  # 型変換with追加オプション
- `0x84 (1000 0100)` INSTANCEOF  # オブジェクトが特定の型/クラスのインスタンスか判定
- `0x85 (1000 0101)` ISSUBTYPE   # サブタイプ判定
- `0x86 (1000 0110)` MAKEGENERICS  # ジェネリック型の生成
- `0x87 (1000 0111)` TYPEPARAM     # ジェネリック型のパラメータ設定
### その他
- `0x00 (0000 0000)` NOP    # 何もしない
- `0xF0 (1111 0000)` CHARAT  # 文字列の指定位置の文字を取得 ([str, index] -> [char])
- `0xFF (1111 1111)` HALT/EOF   # プログラムを終了