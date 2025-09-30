# 自定义行视图完整指南

BRExcelView 支持完全自定义整行的显示，让你可以创建任意复杂的行布局。

## 📋 目录

1. [基础用法](#基础用法)
2. [实现协议](#实现协议)
3. [完整示例](#完整示例)
4. [高级技巧](#高级技巧)

---

## 基础用法

### 方式 1: 实现协议

创建一个遵循 `BRExcelCustomRowView` 协议的自定义视图：

```swift
import BRExcelView

class MyCustomRowView: UIView, BRExcelCustomRowView {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 布局你的自定义视图
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        // 设置约束...
    }
    
    // 实现协议方法
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        // 根据 model 配置视图
        if model.cells.count > 0 {
            titleLabel.text = model.cells[0].text
        }
        if model.cells.count > 1 {
            subtitleLabel.text = model.cells[1].text
        }
    }
}
```

### 使用自定义行视图

```swift
// 创建行数据
let customRow = BRExcelRowModel(
    cells: [
        BRExcelCellModel(text: "标题"),
        BRExcelCellModel(text: "副标题")
    ],
    height: 80,
    customRowViewType: MyCustomRowView.self
)

var rows: [BRExcelRowModel] = []
rows.append(customRow)

excelView.setData(rows: rows)
```

---

## 方式 2: 使用配置闭包

如果不想创建新类，可以使用配置闭包：

```swift
// 创建一个通用的自定义视图类
class GenericCustomRowView: UIView, BRExcelCustomRowView {
    let containerStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerStack.axis = .horizontal
        containerStack.spacing = 8
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        // 默认实现，可以被闭包覆盖
    }
}

// 使用配置闭包
let customRow = BRExcelRowModel(
    cells: [BRExcelCellModel(text: "数据")],
    height: 60,
    customRowViewType: GenericCustomRowView.self,
    customRowViewConfiguration: { view, model, columnWidths in
        guard let customView = view as? GenericCustomRowView else { return }
        
        // 自定义配置
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .systemYellow
        
        let label = UILabel()
        label.text = model.cells.first?.text
        label.font = .boldSystemFont(ofSize: 16)
        
        customView.containerStack.addArrangedSubview(imageView)
        customView.containerStack.addArrangedSubview(label)
    }
)
```

---

## 完整示例

### 示例 1: 卡片式行视图

```swift
class CardRowView: UIView, BRExcelCustomRowView {
    
    private let cardContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statusBadge = UILabel()
    private let chevronIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 卡片容器
        cardContainer.backgroundColor = .white
        cardContainer.layer.cornerRadius = 12
        cardContainer.layer.shadowColor = UIColor.black.cgColor
        cardContainer.layer.shadowOpacity = 0.1
        cardContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardContainer.layer.shadowRadius = 4
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardContainer)
        
        // 标题
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(titleLabel)
        
        // 副标题
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(subtitleLabel)
        
        // 状态徽章
        statusBadge.font = .systemFont(ofSize: 12)
        statusBadge.textAlignment = .center
        statusBadge.layer.cornerRadius = 4
        statusBadge.clipsToBounds = true
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(statusBadge)
        
        // 箭头图标
        chevronIcon.image = UIImage(systemName: "chevron.right")
        chevronIcon.tintColor = .systemGray3
        chevronIcon.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(chevronIcon)
        
        // 约束
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cardContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            cardContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cardContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadge.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadge.leadingAnchor, constant: -8),
            
            statusBadge.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            statusBadge.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -12),
            statusBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            statusBadge.heightAnchor.constraint(equalToConstant: 24),
            
            chevronIcon.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            chevronIcon.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            chevronIcon.widthAnchor.constraint(equalToConstant: 12),
            chevronIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        guard model.cells.count >= 3 else { return }
        
        titleLabel.text = model.cells[0].text
        subtitleLabel.text = model.cells[1].text
        
        // 状态配置
        let status = model.cells[2].text
        statusBadge.text = status
        
        switch status {
        case "已完成":
            statusBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            statusBadge.textColor = .systemGreen
        case "进行中":
            statusBadge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
            statusBadge.textColor = .systemOrange
        default:
            statusBadge.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            statusBadge.textColor = .systemGray
        }
    }
}

// 使用
let cardRow = BRExcelRowModel(
    cells: [
        BRExcelCellModel(text: "项目 A"),
        BRExcelCellModel(text: "截止日期：2024-12-31"),
        BRExcelCellModel(text: "进行中")
    ],
    height: 80,
    customRowViewType: CardRowView.self
)
```

### 示例 2: 可交互的行视图

```swift
class InteractiveRowView: UIView, BRExcelCustomRowView {
    
    private let titleLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let switchControl = UISwitch()
    
    var onButtonTap: (() -> Void)?
    var onSwitchToggle: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        actionButton.setTitle("操作", for: .normal)
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        
        switchControl.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -16)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        if let text = model.cells.first?.text {
            titleLabel.text = text
        }
    }
    
    @objc private func buttonTapped() {
        onButtonTap?()
    }
    
    @objc private func switchToggled() {
        onSwitchToggle?(switchControl.isOn)
    }
}

// 使用
let interactiveRow = BRExcelRowModel(
    cells: [BRExcelCellModel(text: "启用通知")],
    height: 50,
    customRowViewType: InteractiveRowView.self,
    customRowViewConfiguration: { view, model, _ in
        guard let interactiveView = view as? InteractiveRowView else { return }
        
        interactiveView.onButtonTap = {
            print("按钮被点击")
        }
        
        interactiveView.onSwitchToggle = { isOn in
            print("开关状态: \(isOn)")
        }
    }
)
```

### 示例 3: 进度条行视图

```swift
class ProgressRowView: UIView, BRExcelCustomRowView {
    
    private let nameLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let percentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
        
        percentLabel.font = .systemFont(ofSize: 12)
        percentLabel.textColor = .systemGray
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            
            progressView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8),
            
            percentLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            percentLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        guard model.cells.count >= 2 else { return }
        
        nameLabel.text = model.cells[0].text
        
        if let progressValue = Float(model.cells[1].text) {
            let progress = progressValue / 100.0
            progressView.progress = progress
            percentLabel.text = "\(Int(progressValue))%"
            
            // 根据进度设置颜色
            if progress >= 0.8 {
                progressView.progressTintColor = .systemGreen
            } else if progress >= 0.5 {
                progressView.progressTintColor = .systemOrange
            } else {
                progressView.progressTintColor = .systemRed
            }
        }
    }
}

// 使用
let progressRow = BRExcelRowModel(
    cells: [
        BRExcelCellModel(text: "项目完成度"),
        BRExcelCellModel(text: "75")
    ],
    height: 60,
    customRowViewType: ProgressRowView.self
)
```

---

## 高级技巧

### 1. 混合使用默认行和自定义行

```swift
var rows: [BRExcelRowModel] = []

// 默认表头
rows.append(BRExcelRowModel(
    cells: headerCells,
    isHeader: true
))

// 自定义行
rows.append(BRExcelRowModel(
    cells: [BRExcelCellModel(text: "特殊行")],
    height: 80,
    customRowViewType: CardRowView.self
))

// 普通行
rows.append(BRExcelRowModel(
    cells: normalCells
))

excelView.setData(rows: rows)
```

### 2. 响应列宽变化

```swift
func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
    // 使用列宽信息来调整布局
    if columnWidths.count > 0 {
        titleLabel.widthAnchor.constraint(equalToConstant: columnWidths[0]).isActive = true
    }
}
```

### 3. 访问行数据的所有信息

```swift
func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
    // 访问单元格模型的所有属性
    for (index, cell) in model.cells.enumerated() {
        print("Cell \(index):")
        print("  Text: \(cell.text)")
        print("  Color: \(cell.backgroundColor)")
        print("  Font: \(cell.font)")
        
        // 使用富文本
        if let attributedText = cell.attributedText {
            // 处理富文本
        }
        
        // 使用自定义视图
        if let customView = cell.customView {
            // 处理自定义视图
        }
    }
}
```

---

## 🎯 最佳实践

1. **性能**：避免在 `configure` 方法中创建复杂的视图层次，在 `init` 中完成布局
2. **复用**：创建可复用的自定义行视图类
3. **一致性**：保持自定义行与表格其他部分的视觉一致性
4. **响应式**：利用 `columnWidths` 参数实现响应式布局
5. **数据驱动**：让 `BRExcelRowModel` 驱动视图状态，而不是硬编码

享受完全自定义的灵活性！🎨
