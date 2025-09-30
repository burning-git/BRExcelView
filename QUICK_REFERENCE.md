# BRExcelView 快速参考

## 🚀 快速开始

```swift
import BRExcelView

let excelView = BRExcelView()
let header = ["Name", "Age", "City"]
let data = [["Alice", "25", "NYC"]]
excelView.setData(header: header, data: data)
```

## 📋 单元格自定义速查

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `text` | String | - | 显示文本 |
| `widthType` | BRExcelCellWidthType | `.auto` | 宽度类型 |
| `textAlignment` | NSTextAlignment | `.center` | 文本对齐 |
| `font` | UIFont | `.systemFont(14)` | 字体 |
| `textColor` | UIColor | `.darkText` | 文字颜色 |
| `backgroundColor` | UIColor | `.white` | 背景色 |
| `contentInsets` | UIEdgeInsets | `8,8,8,8` | 内边距 |
| `borderColor` | UIColor | `.lightGray` | 边框颜色 |
| `borderWidth` | CGFloat | `0.5` | 边框宽度 |
| `cornerRadius` | CGFloat | `0` | 圆角 |
| `attributedText` | NSAttributedString? | `nil` | 富文本 |
| `customView` | UIView? | `nil` | 自定义视图 |

## 📐 列宽类型

```swift
.fixed(120)      // 固定 120px
.auto            // 根据内容自适应
.flexible        // 弹性宽度，填充剩余空间
```

## 🎨 表格级别配置

```swift
// 尺寸
excelView.maxHeight = 400
excelView.maxWidth = 600
excelView.enableAutoFit = false

// 边框
excelView.tableBorderColor = .gray
excelView.tableBorderWidth = 1
excelView.tableCornerRadius = 12

// 分隔线
excelView.separatorStyle = .default
excelView.separatorStyle = .none
excelView.separatorStyle = SeparatorStyle(
    color: .gray,
    width: 1,
    showHorizontal: true,
    showVertical: false
)

// 滚动
excelView.showsScrollIndicators = true
excelView.bounces = true
```

## 💡 常用代码片段

### 创建表头

```swift
BRExcelCellModel(
    text: "表头",
    font: .boldSystemFont(ofSize: 16),
    textColor: .white,
    backgroundColor: .systemBlue,
    borderWidth: 0
)
```

### 富文本

```swift
let attr = NSMutableAttributedString(string: "Hello World")
attr.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(0, 5))
let cell = BRExcelCellModel(text: "", attributedText: attr)
```

### 自定义视图

```swift
let btn = UIButton()
btn.setTitle("点击", for: .normal)
let cell = BRExcelCellModel(text: "", customView: btn)
```

### 圆角单元格

```swift
BRExcelCellModel(
    text: "圆角",
    borderColor: .blue,
    borderWidth: 2,
    cornerRadius: 8
)
```

## 🎯 三种使用方式

### 1. 最简单

```swift
excelView.setData(
    header: ["A", "B"],
    data: [["1", "2"]]
)
```

### 2. 带配置

```swift
excelView.setData(
    header: ["A", "B"],
    data: [["1", "2"]],
    headerHeight: 50,
    rowHeight: 44,
    columnWidthTypes: [.fixed(100), .flexible]
)
```

### 3. 完全自定义

```swift
var rows: [BRExcelRowModel] = []
rows.append(BRExcelRowModel(cells: headerCells, isHeader: true))
rows.append(BRExcelRowModel(cells: dataCells))
excelView.setData(rows: rows)
```

## 📱 常见场景

### 斑马纹

```swift
let bgColor = index % 2 == 0 ? .white : .systemGray6
BRExcelCellModel(text: "...", backgroundColor: bgColor)
```

### 高亮数值

```swift
let color = value > 90 ? UIColor.green : .red
BRExcelCellModel(text: "\(value)", textColor: color)
```

### 带图标

```swift
let stack = UIStackView()
stack.addArrangedSubview(UIImageView(image: icon))
stack.addArrangedSubview(UILabel())
BRExcelCellModel(text: "", customView: stack)
```

---

📚 更多详情查看 `README.md` 和 `CUSTOMIZATION_GUIDE.md`
