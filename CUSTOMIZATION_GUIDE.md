# BRExcelView 自定义指南

完整的自定义功能说明，让你的表格独一无二！

## 📋 目录

1. [单元格级别自定义](#单元格级别自定义)
2. [表格级别自定义](#表格级别自定义)
3. [高级自定义](#高级自定义)
4. [完整示例](#完整示例)

---

## 单元格级别自定义

### 1. 基础样式

```swift
let cell = BRExcelCellModel(
    text: "自定义单元格",
    widthType: .fixed(120),
    textAlignment: .left,
    font: .boldSystemFont(ofSize: 16),
    textColor: .systemBlue,
    backgroundColor: .systemGray6
)
```

### 2. 边框和圆角

```swift
let cell = BRExcelCellModel(
    text: "圆角单元格",
    borderColor: .systemBlue,      // 边框颜色
    borderWidth: 2.0,               // 边框宽度
    cornerRadius: 8                 // 圆角半径
)
```

### 3. 内边距

```swift
let cell = BRExcelCellModel(
    text: "自定义内边距",
    contentInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
)
```

### 4. 富文本

```swift
let attributedString = NSMutableAttributedString(string: "富文本内容")
attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: 3))
attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location: 0, length: 3))

let cell = BRExcelCellModel(
    text: "",  // 使用富文本时 text 可以为空
    attributedText: attributedString
)
```

### 5. 完全自定义视图

```swift
// 创建自定义视图
let customView = UIStackView()
customView.axis = .horizontal
customView.spacing = 4

let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
imageView.tintColor = .systemYellow
let label = UILabel()
label.text = "⭐️ 5.0"

customView.addArrangedSubview(imageView)
customView.addArrangedSubview(label)

// 使用自定义视图
let cell = BRExcelCellModel(
    text: "",
    widthType: .fixed(100),
    customView: customView
)
```

---

## 表格级别自定义

### 1. 整体边框和圆角

```swift
let excelView = BRExcelView()

// 表格边框
excelView.tableBorderColor = .systemGray3
excelView.tableBorderWidth = 1

// 表格圆角
excelView.tableCornerRadius = 12
```

### 2. 分隔线样式

```swift
// 方式 1: 使用预设样式
excelView.separatorStyle = .default  // 默认分隔线
excelView.separatorStyle = .none     // 无分隔线

// 方式 2: 自定义分隔线
excelView.separatorStyle = BRExcelView.SeparatorStyle(
    color: .systemGray4,     // 分隔线颜色
    width: 1.0,              // 分隔线宽度
    showHorizontal: true,    // 显示横向分隔线
    showVertical: false      // 隐藏纵向分隔线
)
```

### 3. 滚动配置

```swift
// 显示滚动指示器
excelView.showsScrollIndicators = true

// 滚动指示器颜色
excelView.scrollIndicatorColor = .black

// 启用弹性滚动
excelView.bounces = true
```

### 4. 尺寸限制

```swift
// 最大高度（超过则纵向滚动）
excelView.maxHeight = 400

// 最大宽度（超过则横向滚动）
excelView.maxWidth = 600

// 自动填充宽度
excelView.enableAutoFit = false  // 内容宽度
excelView.enableAutoFit = true   // 填充视图宽度
```

---

## 高级自定义

### 1. 混合列宽类型

```swift
let columnWidthTypes: [BRExcelCellWidthType] = [
    .fixed(60),      // ID 列：固定 60px
    .auto,           // 姓名列：根据内容自适应
    .flexible,       // 描述列：弹性宽度，填充剩余空间
    .fixed(100)      // 操作列：固定 100px
]

excelView.setData(
    header: ["ID", "姓名", "描述", "操作"],
    data: data,
    columnWidthTypes: columnWidthTypes
)
```

### 2. 不同风格的表头

```swift
let headerCells = [
    BRExcelCellModel(
        text: "产品名称",
        widthType: .fixed(150),
        font: .boldSystemFont(ofSize: 16),
        textColor: .white,
        backgroundColor: .systemBlue,
        borderColor: .clear,
        borderWidth: 0,
        cornerRadius: 0
    ),
    BRExcelCellModel(
        text: "价格",
        widthType: .fixed(100),
        font: .boldSystemFont(ofSize: 16),
        textColor: .white,
        backgroundColor: .systemBlue
    )
]

let headerRow = BRExcelRowModel(cells: headerCells, height: 50, isHeader: true)
```

### 3. 斑马纹效果

```swift
var rows: [BRExcelRowModel] = []

// 添加表头
rows.append(headerRow)

// 添加数据行（斑马纹）
for (index, rowData) in data.enumerated() {
    let isEven = index % 2 == 0
    let bgColor: UIColor = isEven ? .white : .systemGray6
    
    let cells = rowData.map { text in
        BRExcelCellModel(
            text: text,
            backgroundColor: bgColor
        )
    }
    
    rows.append(BRExcelRowModel(cells: cells))
}

excelView.setData(rows: rows)
```

### 4. 带图标的单元格

```swift
// 创建带图标的自定义视图
func createIconCell(icon: String, text: String) -> BRExcelCellModel {
    let container = UIStackView()
    container.axis = .horizontal
    container.spacing = 8
    container.alignment = .center
    
    let imageView = UIImageView(image: UIImage(systemName: icon))
    imageView.tintColor = .systemBlue
    imageView.contentMode = .scaleAspectFit
    imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    let label = UILabel()
    label.text = text
    label.font = .systemFont(ofSize: 14)
    
    container.addArrangedSubview(imageView)
    container.addArrangedSubview(label)
    
    return BRExcelCellModel(
        text: "",
        widthType: .auto,
        customView: container
    )
}

// 使用
let cell = createIconCell(icon: "checkmark.circle.fill", text: "已完成")
```

### 5. 按钮/交互元素

```swift
// 创建带按钮的单元格
func createButtonCell(title: String, action: @escaping () -> Void) -> BRExcelCellModel {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.addAction(UIAction { _ in action() }, for: .touchUpInside)
    
    return BRExcelCellModel(
        text: "",
        widthType: .fixed(80),
        customView: button,
        contentInsets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    )
}

// 使用
let actionCell = createButtonCell(title: "查看") {
    print("按钮被点击了！")
}
```

---

## 完整示例

### 示例 1: 现代化卡片风格

```swift
let excelView = BRExcelView()

// 表格整体样式
excelView.tableBorderColor = .systemGray4
excelView.tableBorderWidth = 1
excelView.tableCornerRadius = 12
excelView.backgroundColor = .white
excelView.separatorStyle = BRExcelView.SeparatorStyle(
    color: .systemGray5,
    width: 1,
    showHorizontal: true,
    showVertical: false
)

var rows: [BRExcelRowModel] = []

// 现代化表头
let headerCells = [
    BRExcelCellModel(
        text: "产品",
        widthType: .flexible,
        font: .boldSystemFont(ofSize: 16),
        textColor: .white,
        backgroundColor: .systemIndigo,
        borderWidth: 0
    ),
    BRExcelCellModel(
        text: "状态",
        widthType: .fixed(100),
        font: .boldSystemFont(ofSize: 16),
        textColor: .white,
        backgroundColor: .systemIndigo,
        borderWidth: 0
    ),
    BRExcelCellModel(
        text: "价格",
        widthType: .fixed(100),
        font: .boldSystemFont(ofSize: 16),
        textColor: .white,
        backgroundColor: .systemIndigo,
        borderWidth: 0
    )
]
rows.append(BRExcelRowModel(cells: headerCells, height: 50, isHeader: true))

// 数据行
rows.append(BRExcelRowModel(cells: [
    BRExcelCellModel(text: "iPhone 15 Pro", widthType: .flexible, textAlignment: .left),
    BRExcelCellModel(text: "✅ 在售", widthType: .fixed(100)),
    BRExcelCellModel(text: "$999", widthType: .fixed(100), textColor: .systemGreen, font: .boldSystemFont(ofSize: 16))
], height: 44))

excelView.setData(rows: rows)
```

### 示例 2: 极简风格

```swift
let excelView = BRExcelView()

// 极简样式：无边框，只有分隔线
excelView.separatorStyle = BRExcelView.SeparatorStyle(
    color: .systemGray5,
    width: 1,
    showHorizontal: true,
    showVertical: false
)

// 所有单元格无边框
let cells = data.map { rowData in
    rowData.map { text in
        BRExcelCellModel(
            text: text,
            borderWidth: 0  // 无边框
        )
    }
}
```

### 示例 3: 高亮重要数据

```swift
// 根据数值高亮显示
func createHighlightCell(value: Int) -> BRExcelCellModel {
    let (color, bgColor): (UIColor, UIColor)
    
    if value >= 90 {
        color = .systemGreen
        bgColor = UIColor.systemGreen.withAlphaComponent(0.1)
    } else if value >= 60 {
        color = .systemOrange
        bgColor = UIColor.systemOrange.withAlphaComponent(0.1)
    } else {
        color = .systemRed
        bgColor = UIColor.systemRed.withAlphaComponent(0.1)
    }
    
    return BRExcelCellModel(
        text: "\(value)",
        textColor: color,
        backgroundColor: bgColor,
        borderColor: color,
        borderWidth: 1,
        cornerRadius: 4
    )
}
```

---

## 🎨 样式预设

为方便使用，你可以创建样式预设：

```swift
extension BRExcelCellModel {
    // 表头样式
    static func header(text: String, width: BRExcelCellWidthType = .flexible) -> BRExcelCellModel {
        return BRExcelCellModel(
            text: text,
            widthType: width,
            font: .boldSystemFont(ofSize: 16),
            textColor: .white,
            backgroundColor: .systemBlue,
            borderWidth: 0
        )
    }
    
    // 普通单元格样式
    static func normal(text: String, width: BRExcelCellWidthType = .auto) -> BRExcelCellModel {
        return BRExcelCellModel(
            text: text,
            widthType: width,
            borderColor: .systemGray5,
            borderWidth: 0.5
        )
    }
    
    // 强调样式
    static func emphasized(text: String, width: BRExcelCellWidthType = .auto) -> BRExcelCellModel {
        return BRExcelCellModel(
            text: text,
            widthType: width,
            font: .boldSystemFont(ofSize: 14),
            textColor: .systemBlue
        )
    }
}

// 使用预设
let cell1 = BRExcelCellModel.header(text: "标题", width: .flexible)
let cell2 = BRExcelCellModel.normal(text: "内容")
let cell3 = BRExcelCellModel.emphasized(text: "重要")
```

---

## 💡 最佳实践

1. **性能优化**：避免在单元格中使用过于复杂的自定义视图
2. **一致性**：保持相同类型数据的样式一致
3. **可访问性**：确保文本颜色和背景色有足够的对比度
4. **响应式**：使用 `.flexible` 让表格适应不同屏幕尺寸
5. **分层**：使用边框和阴影创建视觉层次

愉快地定制你的表格！🎉
