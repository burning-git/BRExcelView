# 问题排查指南

## 错误: "Cannot find type 'BRExcelCustomRowView' in scope"

### 原因
这个错误说明 BRExcelView Package 还没有被正确添加到 Xcode 项目中。

### 解决方案

#### 方案 1: 在 Xcode 中添加 Package（推荐）

1. **打开项目**
   - 双击 `BRExcelView.xcodeproj`

2. **添加 Package Dependency**
   - 在项目导航器中，点击最上面的项目文件（蓝色 BRExcelView 图标）
   - 在中间面板，选择 **项目（Project）**，不是 Target
   - 切换到 **"Package Dependencies"** 标签
   - 点击 **"+"** 按钮
   - 点击左下角的 **"Add Local..."** 按钮
   - 选择当前文件夹（包含 Package.swift 的文件夹）：
     ```
     /Users/gitburning/Desktop/Work/APEUni/Demo/ScollerExcelView/BRExcelView
     ```
   - 点击 **"Add Package"**

3. **添加到 Target**
   - 选择 **Target（BRExcelView）**
   - 切换到 **"General"** 标签
   - 在 **"Frameworks, Libraries, and Embedded Content"** 部分
   - 点击 **"+"** 按钮
   - 选择 **"BRExcelView"** library
   - 点击 **"Add"**

4. **清理并重新编译**
   - 按 `Cmd + Shift + K` 清理项目
   - 按 `Cmd + B` 编译项目

#### 方案 2: 暂时不使用自定义行视图

如果添加 Package 遇到困难，可以先注释掉自定义行视图的示例：

在 `ViewController.swift` 中：

```swift
private func loadSampleData() {
    // 使用简单示例
    loadSampleDataSimple()
    
    // 暂时注释自定义行视图示例
    // loadCustomRowViewExample()
}
```

然后取消注释 `loadSampleDataSimple()` 中的代码。

#### 方案 3: 检查 Package 路径

确保 `Package.swift` 文件在正确的位置：

```
BRExcelView/
├── Package.swift           ← 必须在这里
├── Sources/
│   └── BRExcelView/
│       ├── BRExcelView.swift
│       ├── BRExcelCellModel.swift  ← BRExcelCustomRowView 在这里定义
│       ├── BRExcelCellView.swift
│       └── BRExcelRowView.swift
├── BRExcelView/           ← Demo 项目
│   └── ViewController.swift
└── BRExcelView.xcodeproj
```

#### 方案 4: 重启 Xcode

有时 Xcode 需要重启才能识别新添加的 Package：

1. 完全退出 Xcode（Cmd + Q）
2. 删除 DerivedData：
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. 重新打开项目
4. 清理并编译（Cmd + Shift + K，然后 Cmd + B）

---

## 其他常见问题

### 问题: "Module 'BRExcelView' not found"

**解决方案：**
1. 确认 Package Dependencies 中已添加 BRExcelView
2. 确认 Target 的 Frameworks 中已添加 BRExcelView
3. 清理项目并重新编译

### 问题: 编译成功但运行时崩溃

**解决方案：**
1. 检查是否正确实现了 `BRExcelCustomRowView` 协议
2. 确保 `configure(with:columnWidths:)` 方法已实现
3. 检查控制台错误信息

### 问题: 自定义行视图不显示

**解决方案：**
1. 确认 `customRowViewType` 参数已正确设置
2. 检查行高是否足够显示内容
3. 确认约束是否正确设置

---

## 验证 Package 是否正确安装

在 `ViewController.swift` 中添加测试代码：

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // 测试 Package 是否正确导入
    print("BRExcelView 类型: \(type(of: BRExcelView.self))")
    print("BRExcelCellModel 类型: \(type(of: BRExcelCellModel.self))")
    
    setupExcelView()
    loadSampleData()
}
```

如果控制台能正确打印类型信息，说明 Package 已正确导入。

---

## 需要帮助？

如果以上方案都无法解决问题，请：

1. 检查 Xcode 版本（需要 Xcode 15.0+）
2. 检查 iOS 部署目标（需要 iOS 13.0+）
3. 查看完整的错误日志
4. 确认项目设置中的 Swift 版本（需要 Swift 5.9+）
