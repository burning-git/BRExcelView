# BRExcelView

一个功能强大、灵活的 iOS 表格视图组件，支持自适应宽度、固定宽度和弹性宽度，类似 Excel 表格的显示效果。

> 🎉 **新增完整示例集合**: 查看 `Examples/` 文件夹获取 **13 个可直接运行的使用示例**！
> 
> - 📖 **快速入门**: [QuickStartGuide.swift](./Examples/QuickStartGuide.swift) - 6 个从简单到复杂的示例
> - 🎨 **精美视图**: [CustomRowViewExamples.swift](./Examples/CustomRowViewExamples.swift) - 4 个生产级别的自定义行视图
> - 🏢 **实际场景**: [RealWorldExamples.swift](./Examples/RealWorldExamples.swift) - 成绩单、订单列表、项目跟踪
> 
> 📚 **详见**: [示例使用说明.md](./示例使用说明.md) | [Examples/README.md](./Examples/README.md)

## 特性

✅ **灵活的列宽配置**
- 固定宽度 (`.fixed`)
- 自适应内容宽度 (`.auto`)
- 弹性宽度 (`.flexible`)

✅ **智能滚动**
- 横向滚动：内容宽度超过视图宽度时自动启用
- 纵向滚动：可设置最大高度限制

✅ **自适应尺寸**
- 高度根据内容自动调整
- 宽度根据内容自动调整
- 支持设置最大宽度和最大高度

✅ **极致自定义**
- 🎨 单元格级别：字体、颜色、对齐、边框、圆角、内边距
- 🖼️ 富文本支持：使用 NSAttributedString
- 🎯 自定义视图：嵌入任意 UIView（按钮、图标、开关等）
- 📏 表格级别：整体边框、圆角、分隔线样式
- 🎭 主题支持：轻松创建不同风格的表格
- 🔧 自定义行视图：完全自定义整行的布局和交互

✅ **性能优化**
- 避免不必要的视图重建
- 智能布局更新
- 高效的约束管理

## 安装

### Swift Package Manager

在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/your-username/BRExcelView.git", from: "1.0.0")
]
```

或在 Xcode 中：
1. File > Add Package Dependencies...
2. 输入仓库 URL
3. 选择版本并添加

## 快速开始

### 基础用法

```swift
import BRExcelView

// 创建表格视图
let excelView = BRExcelView()
excelView.enableAutoFit = false
excelView.maxHeight = 400

// 简单的数据配置
let header = ["Name", "Age", "City"]
let data = [
    ["Alice", "25", "New York"],
    ["Bob", "30", "London"],
    ["Charlie", "35", "Tokyo"]
]

excelView.setData(header: header, data: data)
```

### 高级用法 - 混合列宽类型

```swift
// 配置不同的列宽类型
let columnWidthTypes: [BRExcelCellWidthType] = [
    .fixed(120),   // 第一列：固定 120px
    .auto,         // 第二列：根据内容自适应
    .flexible,     // 第三列：弹性宽度，填充剩余空间
]

excelView.setData(
    header: header,
    data: data,
    headerHeight: 50,
    rowHeight: 44,
    columnWidthTypes: columnWidthTypes
)
```

### 完全自定义 - 使用 Model

```swift
var rows: [BRExcelRowModel] = []

// 自定义表头
let headerCells = [
    BRExcelCellModel(
        text: "Product",
        widthType: .fixed(150),
        textAlignment: .left,
        font: .boldSystemFont(ofSize: 16),
        backgroundColor: .systemGray5,
        contentInsets: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    ),
    BRExcelCellModel(
        text: "Price",
        widthType: .fixed(100),
        backgroundColor: .systemGray5
    ),
    BRExcelCellModel(
        text: "Description",
        widthType: .flexible,
        backgroundColor: .systemGray5
    )
]
rows.append(BRExcelRowModel(cells: headerCells, height: 50, isHeader: true))

// 自定义数据行
let dataCells = [
    BRExcelCellModel(text: "iPhone 15", widthType: .fixed(150), textAlignment: .left),
    BRExcelCellModel(text: "$999", widthType: .fixed(100)),
    BRExcelCellModel(text: "Latest model", widthType: .flexible)
]
rows.append(BRExcelRowModel(cells: dataCells, height: 44))

excelView.setData(rows: rows)
```

## API 文档

### BRExcelView

主要的表格视图组件。

**属性：**
- `enableAutoFit: Bool` - 启用自动填充宽度（默认 false）
- `maxHeight: CGFloat?` - 最大高度限制
- `maxWidth: CGFloat?` - 最大宽度限制

**方法：**
```swift
// 简单配置
func setData(
    header: [String]?,
    data: [[String]],
    headerHeight: CGFloat = 50,
    rowHeight: CGFloat = 44,
    columnWidthTypes: [BRExcelCellWidthType]? = nil
)

// 完全自定义
func setData(rows: [BRExcelRowModel])

// 刷新数据
func reloadData()
```

### BRExcelCellWidthType

列宽类型枚举。

```swift
public enum BRExcelCellWidthType {
    case fixed(CGFloat)      // 固定宽度
    case auto                // 自适应内容宽度
    case flexible            // 弹性宽度
}
```

### BRExcelCellModel

单元格数据模型。

**属性：**
- `text: String` - 显示文本
- `widthType: BRExcelCellWidthType` - 宽度类型
- `minWidth: CGFloat` - 最小宽度（默认 80）
- `textAlignment: NSTextAlignment` - 文本对齐方式
- `font: UIFont` - 字体
- `textColor: UIColor` - 文本颜色
- `backgroundColor: UIColor` - 背景色
- `contentInsets: UIEdgeInsets` - 内边距

### BRExcelRowModel

行数据模型。

**属性：**
- `cells: [BRExcelCellModel]` - 单元格数组
- `height: CGFloat` - 行高
- `isHeader: Bool` - 是否为表头

## 自定义示例

### 🎨 富文本单元格

```swift
let attributedString = NSMutableAttributedString(string: "特价 ¥99")
attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: 2))
attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location: 3, length: 3))

let cell = BRExcelCellModel(
    text: "",
    attributedText: attributedString
)
```

### 🎯 自定义视图（带图标）

```swift
let iconStack = UIStackView()
iconStack.axis = .horizontal
iconStack.spacing = 4

let icon = UIImageView(image: UIImage(systemName: "star.fill"))
icon.tintColor = .systemYellow
let label = UILabel()
label.text = "5.0"

iconStack.addArrangedSubview(icon)
iconStack.addArrangedSubview(label)

let cell = BRExcelCellModel(
    text: "",
    customView: iconStack
)
```

### 📏 表格整体样式

```swift
excelView.tableBorderColor = .systemGray3
excelView.tableBorderWidth = 1
excelView.tableCornerRadius = 12
excelView.separatorStyle = BRExcelView.SeparatorStyle(
    color: .systemGray5,
    width: 1,
    showHorizontal: true,
    showVertical: false
)
```

### 🌈 单元格边框和圆角

```swift
let cell = BRExcelCellModel(
    text: "圆角单元格",
    borderColor: .systemBlue,
    borderWidth: 2,
    cornerRadius: 8
)
```

### 🔧 自定义整行视图

```swift
// 1. 创建自定义行视图
class MyCustomRowView: UIView, BRExcelCustomRowView {
    // 实现你的自定义布局
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        // 配置视图
    }
}

// 2. 使用自定义行
let customRow = BRExcelRowModel(
    cells: [BRExcelCellModel(text: "数据")],
    height: 80,
    customRowViewType: MyCustomRowView.self
)

excelView.setData(rows: [customRow])
```

查看 `CUSTOMIZATION_GUIDE.md` 获取完整的单元格自定义指南！  
查看 `CUSTOM_ROW_VIEW_GUIDE.md` 获取完整的自定义行视图指南！

## 要求

- iOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## 作者

git burning

## 许可证

MIT License
