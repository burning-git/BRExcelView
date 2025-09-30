# 如何在 Xcode 项目中使用 BRExcelView Package

本指南详细说明如何将 BRExcelView Swift Package 集成到现有的 Xcode 项目中。

## 📋 前提条件

- Xcode 15.0 或更高版本
- iOS 13.0 或更高部署目标
- Swift 5.9 或更高版本

## 🚀 快速开始

### 步骤 1: 打开项目设置

1. 在 Xcode 中打开 `BRExcelView.xcodeproj`
2. 在项目导航器中，点击最上面的蓝色项目图标（BRExcelView）

### 步骤 2: 添加 Package Dependency

#### 选项 A: 添加本地 Package（开发时推荐）

1. 在中间面板，选择 **项目（Project）**，不是 Target
   ```
   PROJECT
   ├── BRExcelView  ← 选择这个
   └── ...
   
   TARGETS
   └── BRExcelView
   ```

2. 点击顶部的 **"Package Dependencies"** 标签

3. 点击左下角的 **"+"** 按钮

4. 在弹出窗口中：
   - 点击左下角的 **"Add Local..."** 按钮
   - 导航到当前文件夹（包含 Package.swift 的文件夹）：
     ```
     /Users/gitburning/Desktop/Work/APEUni/Demo/ScollerExcelView/BRExcelView
     ```
   - 点击 **"Add Package"**

5. 在 "Choose Package Products" 对话框中：
   - 确认 **"BRExcelView"** 被选中
   - 点击 **"Add Package"**

#### 选项 B: 添加 Git Repository（发布后）

如果你将 Package 发布到了 Git 仓库：

1. 在 Package Dependencies 页面点击 **"+"**
2. 在搜索框中输入 Git 仓库 URL
3. 选择版本规则（建议选择 "Up to Next Major Version"）
4. 点击 **"Add Package"**

### 步骤 3: 添加到 App Target

1. 在左侧选择 **TARGETS** 下的 **BRExcelView**

2. 切换到 **"General"** 标签

3. 滚动到 **"Frameworks, Libraries, and Embedded Content"** 部分

4. 点击 **"+"** 按钮

5. 在弹出列表中找到并选择 **"BRExcelView"**（带有 package 图标）

6. 点击 **"Add"**

### 步骤 4: 验证安装

1. 在 `ViewController.swift` 文件顶部，确认导入语句存在：
   ```swift
   import BRExcelView
   ```

2. 按 **Cmd + B** 编译项目

3. 如果编译成功，说明 Package 已正确安装！

### 步骤 5: 启用自定义行视图示例（可选）

1. 在 `ViewController.swift` 中找到这些行：

   ```swift
   private func loadSampleData() {
       // 方式1: 使用便捷方法（简单场景）
       loadSampleDataSimple()
       
       // 方式3: 自定义行视图示例
       // 详见 TROUBLESHOOTING.md 和 HOW_TO_USE_PACKAGE.md
//        loadCustomRowViewExample()  ← 取消这行注释
   }
   ```

2. 找到文件底部的自定义行视图代码块，取消注释：

   ```swift
   /*
   // MARK: - 自定义行视图示例
   ...
   */
   ```
   
   改为：
   
   ```swift
   // MARK: - 自定义行视图示例
   ...
   ```

3. 重新编译并运行

## 🔧 常见问题

### 问题 1: "Cannot find type 'BRExcelView' in scope"

**原因**: Package 未正确添加到项目

**解决方案**:
1. 检查 Project > Package Dependencies 中是否有 BRExcelView
2. 检查 Target > General > Frameworks 中是否有 BRExcelView
3. 清理项目（Cmd + Shift + K）并重新编译（Cmd + B）

### 问题 2: "Cannot find type 'BRExcelCustomRowView' in scope"

**原因**: 自定义行视图的代码被注释了，或者 Package 未正确导入

**解决方案**:
1. 确认已完成步骤 1-4
2. 确认文件顶部有 `import BRExcelView`
3. 取消自定义行视图代码的注释（见步骤 5）
4. 重新编译

### 问题 3: Package 添加后消失

**原因**: Package 路径可能不正确

**解决方案**:
1. 确保 Package.swift 在项目根目录
2. 删除 Package Dependency 并重新添加
3. 使用绝对路径而不是相对路径
4. 确保 Sources/BRExcelView 目录存在且包含所有必需文件

### 问题 4: 编译卡住或超时

**解决方案**:
1. 关闭 Xcode（Cmd + Q）
2. 删除 DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. 重新打开项目
4. 清理并编译

## 📁 正确的目录结构

确保你的项目结构如下：

```
BRExcelView/
├── Package.swift                    ← Package 定义
├── README.md
├── LICENSE
├── .gitignore
│
├── Sources/                         ← Package 源代码
│   └── BRExcelView/
│       ├── BRExcelView.swift
│       ├── BRExcelCellModel.swift   ← 包含 BRExcelCustomRowView 协议
│       ├── BRExcelCellView.swift
│       └── BRExcelRowView.swift
│
├── Tests/                           ← 测试文件
│   └── BRExcelViewTests/
│       └── BRExcelViewTests.swift
│
├── BRExcelView/                     ← Demo App
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── ViewController.swift         ← 使用示例
│   ├── Base.lproj/
│   └── Assets.xcassets/
│
└── BRExcelView.xcodeproj/          ← Xcode 项目
```

## ✅ 验证清单

使用此清单确认 Package 正确安装：

- [ ] Package.swift 存在于项目根目录
- [ ] Sources/BRExcelView/ 包含所有 5 个 Swift 文件
- [ ] Project > Package Dependencies 显示 BRExcelView
- [ ] Target > General > Frameworks 包含 BRExcelView
- [ ] ViewController.swift 顶部有 `import BRExcelView`
- [ ] 编译成功（Cmd + B）
- [ ] 可以使用 BRExcelView 类型而不报错

## 🎯 下一步

Package 安装成功后，你可以：

1. 查看 `README.md` 了解基本用法
2. 查看 `CUSTOMIZATION_GUIDE.md` 学习自定义选项
3. 查看 `CUSTOM_ROW_VIEW_GUIDE.md` 学习自定义行视图
4. 查看 `ViewController.swift` 中的三个示例方法：
   - `loadSampleDataSimple()` - 基础用法
   - `loadSampleDataWithModels()` - 高级配置
   - `loadCustomRowViewExample()` - 自定义行视图

## 💡 提示

### 开发时的最佳实践

1. **使用本地 Package**
   - 开发时使用本地 Package，方便调试和修改
   - 可以在 Package 代码中添加 `print()` 语句进行调试

2. **清理缓存**
   - 修改 Package 代码后，建议清理项目（Cmd + Shift + K）
   - 必要时删除 DerivedData

3. **版本控制**
   - Package 代码（Sources/）应该提交到版本控制
   - Demo 项目（BRExcelView/）可以分开管理

4. **测试**
   - 在 Tests/ 目录添加单元测试
   - 使用 Cmd + U 运行测试

### 发布到生产环境

准备发布时：

1. 为 Package 打 Git tag：
   ```bash
   git tag 1.0.0
   git push origin 1.0.0
   ```

2. 在其他项目中通过 Git URL 引用：
   ```
   https://github.com/yourusername/BRExcelView.git
   ```

3. 使用语义化版本（Semantic Versioning）：
   - 主版本号：不兼容的 API 修改
   - 次版本号：向下兼容的功能性新增
   - 修订号：向下兼容的问题修正

## 🆘 需要帮助？

如果以上步骤无法解决问题：

1. 查看 `TROUBLESHOOTING.md` 获取更多解决方案
2. 检查 Xcode 控制台的完整错误信息
3. 确认 Swift 和 iOS 版本要求
4. 重启 Xcode 和 Mac（有时真的管用！）

---

**祝编码愉快！** 🎉