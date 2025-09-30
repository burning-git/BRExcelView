# BRExcelView 使用示例集合

这个文件夹包含了 BRExcelView 的各种使用示例，从简单到复杂，从基础用法到实际应用场景。

## 📁 文件说明

### 1. QuickStartGuide.swift - 快速开始 ⭐ 推荐新手

**包含 6 个从简单到复杂的示例：**

- **示例 1**: 最简单的用法（3 行代码创建表格）
- **示例 2**: 配置列宽（固定宽度、自适应、弹性宽度）
- **示例 3**: 自定义样式（颜色、字体、边框）
- **示例 4**: 使用自定义行视图（卡片式布局）
- **示例 5**: 可交互的行（开关、按钮）
- **示例 6**: 混合使用（普通行 + 自定义行）

**特点：**
- ✅ 代码简洁，注释详细
- ✅ 每个示例独立，可单独运行
- ✅ 包含 3 个简单的自定义行视图类
- ✅ 适合快速上手和学习

**使用方法：**
```swift
// 在 ViewController 中调用
example1_SimpleTable(in: excelView)
```

---

### 2. CustomRowViewExamples.swift - 自定义行视图完整示例

**包含 4 个精美的自定义行视图：**

1. **TaskCardRowView** - 任务卡片
   - 带阴影的卡片布局
   - 优先级指示器（彩色左侧条）
   - 状态徽章
   - 图标和日期显示

2. **ProgressRowView** - 进度条
   - 动态颜色（根据进度红/橙/绿）
   - 状态图标
   - 百分比显示
   - 圆角进度条

3. **InteractiveRowView** - 可交互行
   - UISwitch 开关
   - 设置按钮
   - 图标和副标题
   - 交互回调

4. **UserCardRowView** - 用户信息卡片
   - 圆形头像
   - VIP 徽章
   - 用户角色
   - 右侧箭头

**特点：**
- ✅ 生产级别的 UI 设计
- ✅ 完整的约束布局
- ✅ 丰富的视觉效果
- ✅ 可直接用于实际项目

**使用方法：**
```swift
let viewController = ExampleViewController()
present(viewController, animated: true)
```

---

### 3. RealWorldExamples.swift - 真实应用场景

**包含 3 个完整的实际应用场景：**

#### 场景 1: 成绩单 (ScoreCardViewController)
- 学生成绩展示
- 多列数据（科目、分数、等级、排名）
- 标准表格样式

#### 场景 2: 订单列表 (OrderListViewController)
- 电商订单管理
- 订单卡片视图
- 点击交互
- 状态标识（待发货/已完成/已取消）

#### 场景 3: 项目进度跟踪 (ProjectTrackerViewController)
- 项目管理看板
- 进度条显示
- 负责人信息
- 截止日期提醒

**特点：**
- ✅ 真实业务场景
- ✅ 完整的 ViewController 实现
- ✅ 复杂的数据展示
- ✅ 专业的 UI 设计

**使用方法：**
```swift
let vc = OrderListViewController()
navigationController?.pushViewController(vc, animated: true)
```

---

## 🚀 如何使用这些示例

### 方法 1: 在现有项目中集成

1. **添加 BRExcelView Package**
   - 详见根目录的 `HOW_TO_USE_PACKAGE.md`

2. **复制示例代码**
   - 复制需要的示例到你的项目中
   - 根据需要修改数据和样式

3. **运行**
   ```swift
   let vc = DemoViewController()
   present(vc, animated: true)
   ```

### 方法 2: 直接在 Demo 项目中测试

1. **在 ViewController.swift 中使用**
   
   在 `loadSampleData()` 方法中调用示例：
   ```swift
   private func loadSampleData() {
       // 使用快速开始示例
       example6_MixedContent(in: excelView)
   }
   ```

2. **或者创建新的测试页面**
   
   在 SceneDelegate 中替换 rootViewController：
   ```swift
   window?.rootViewController = OrderListViewController()
   ```

---

## 📚 学习路径建议

### 新手入门
1. 先看 `QuickStartGuide.swift` 的示例 1-3
2. 理解基本用法后，尝试示例 4-6
3. 参考 `RealWorldExamples.swift` 中的成绩单场景

### 进阶使用
1. 研究 `CustomRowViewExamples.swift` 中的视图实现
2. 学习约束布局和 UI 设计
3. 尝试修改和扩展这些视图

### 实际开发
1. 参考 `RealWorldExamples.swift` 中的完整场景
2. 根据业务需求定制自己的行视图
3. 结合项目实际情况调整样式

---

## 🎨 自定义提示

### 创建自定义行视图的步骤

1. **创建类并遵循协议**
   ```swift
   class MyCustomRow: UIView, BRExcelCustomRowView {
   ```

2. **初始化 UI**
   ```swift
   override init(frame: CGRect) {
       super.init(frame: frame)
       setupUI()
   }
   ```

3. **实现配置方法**
   ```swift
   func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
       // 从 model.cells 中获取数据
       // 更新 UI
   }
   ```

4. **使用自定义视图**
   ```swift
   let row = BRExcelRowModel(
       cells: [...],
       height: 80,
       customRowViewType: MyCustomRow.self
   )
   ```

---

## 💡 常见问题

### Q1: 自定义行视图不显示？
**A**: 检查以下几点：
- ✓ Package 是否正确导入
- ✓ `customRowViewType` 是否设置
- ✓ 行高是否足够（建议 ≥ 60）
- ✓ 约束是否正确设置

### Q2: 如何处理点击事件？
**A**: 使用 `customRowViewConfiguration` 回调：
```swift
customRowViewConfiguration: { view, model, _ in
    if let myView = view as? MyCustomRow {
        myView.onTap = {
            // 处理点击
        }
    }
}
```

### Q3: 数据如何传递给自定义视图？
**A**: 通过 `BRExcelCellModel` 的 `text` 字段：
```swift
let cells = [
    BRExcelCellModel(text: "数据1"),
    BRExcelCellModel(text: "数据2")
]

// 在 configure 方法中获取
func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
    let data1 = model.cells[0].text
    let data2 = model.cells[1].text
}
```

### Q4: 能否在自定义行中使用图片？
**A**: 可以！使用 `customView` 属性：
```swift
let imageView = UIImageView(image: UIImage(named: "avatar"))
let cell = BRExcelCellModel(text: "", customView: imageView)
```

---

## 📖 更多资源

- **基础文档**: `../README.md`
- **详细配置**: `../CUSTOMIZATION_GUIDE.md`
- **自定义行视图指南**: `../CUSTOM_ROW_VIEW_GUIDE.md`
- **快速参考**: `../QUICK_REFERENCE.md`
- **问题排查**: `../TROUBLESHOOTING.md`

---

## 🎯 示例对比表

| 示例文件 | 难度 | 行数 | 自定义视图 | 交互 | 适用场景 |
|---------|------|------|-----------|------|---------|
| QuickStartGuide | ⭐ | 200 | 3个简单 | ✓ | 快速上手 |
| CustomRowViewExamples | ⭐⭐ | 400 | 4个完整 | ✓ | 学习自定义 |
| RealWorldExamples | ⭐⭐⭐ | 600 | 3个复杂 | ✓ | 实际项目 |

---

**开始探索这些示例，创建你自己的精美表格吧！** 🚀

有任何问题，请查看根目录的文档或提 issue。
