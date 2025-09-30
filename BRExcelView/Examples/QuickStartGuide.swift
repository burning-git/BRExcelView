//
//  QuickStartGuide.swift
//  BRExcelView 快速开始指南
//
//  这个文件包含从简单到复杂的所有使用示例
//

import UIKit
import BRExcelView

// MARK: - 示例 1: 最简单的用法（3 行代码）

func example1_SimpleTable(in excelView: BRExcelView) {
    let header = ["姓名", "年龄", "城市"]
    let data = [
        ["张三", "25", "北京"],
        ["李四", "30", "上海"]
    ]
    
    excelView.setData(header: header, data: data)
}

// MARK: - 示例 2: 配置列宽

func example2_ColumnWidths(in excelView: BRExcelView) {
    let header = ["姓名", "分数", "等级"]
    let data = [
        ["张三", "95", "A"],
        ["李四", "88", "B"]
    ]
    
    // 第一列自适应，第二列固定 100，第三列固定 60
    let columnWidths: [BRExcelCellWidthType] = [.auto, .fixed(100), .fixed(60)]
    
    excelView.setData(header: header, data: data, columnWidthTypes: columnWidths)
}

// MARK: - 示例 3: 自定义样式

func example3_CustomStyle(in excelView: BRExcelView) {
    var rows: [BRExcelRowModel] = []
    
    // 蓝色表头
    let headerRow = BRExcelRowModel(
        cells: [
            BRExcelCellModel(text: "科目", widthType: .auto, textColor: .white, backgroundColor: .systemBlue),
            BRExcelCellModel(text: "成绩", widthType: .fixed(80), textColor: .white, backgroundColor: .systemBlue)
        ],
        height: 50,
        isHeader: true
    )
    rows.append(headerRow)
    
    // 普通行
    let dataRow = BRExcelRowModel(
        cells: [
            BRExcelCellModel(text: "数学", widthType: .auto),
            BRExcelCellModel(text: "95", widthType: .fixed(80), textColor: .systemGreen)
        ],
        height: 44
    )
    rows.append(dataRow)
    
    excelView.setData(rows: rows)
}

// MARK: - 示例 4: 使用自定义行视图

func example4_CustomRowView(in excelView: BRExcelView) {
    var rows: [BRExcelRowModel] = []
    
    // 表头
    let header = BRExcelRowModel(
        cells: [BRExcelCellModel(text: "任务列表", widthType: .flexible)],
        height: 50,
        isHeader: true
    )
    rows.append(header)
    
    // 自定义卡片行
    let cardRow = BRExcelRowModel(
        cells: [
            BRExcelCellModel(text: "完成项目文档"),
            BRExcelCellModel(text: "进行中")
        ],
        height: 80,
        customRowViewType: SimpleCardView.self  // 使用自定义视图
    )
    rows.append(cardRow)
    
    excelView.setData(rows: rows)
}

// MARK: - 示例 5: 可交互的行

func example5_InteractiveRow(in excelView: BRExcelView) {
    var rows: [BRExcelRowModel] = []
    
    let interactiveRow = BRExcelRowModel(
        cells: [
            BRExcelCellModel(text: "启用通知"),
            BRExcelCellModel(text: "true")
        ],
        height: 60,
        customRowViewType: SettingRowView.self,
        customRowViewConfiguration: { view, model, _ in
            // 配置交互回调
            if let settingView = view as? SettingRowView {
                settingView.onToggle = { isOn in
                    print("通知开关: \(isOn)")
                }
            }
        }
    )
    rows.append(interactiveRow)
    
    excelView.setData(rows: rows)
}

// MARK: - 示例 6: 混合使用

func example6_MixedContent(in excelView: BRExcelView) {
    var rows: [BRExcelRowModel] = []
    
    // 1. 普通表头
    rows.append(BRExcelRowModel(
        cells: [BRExcelCellModel(text: "项目管理", widthType: .flexible)],
        height: 50,
        isHeader: true
    ))
    
    // 2. 自定义卡片行
    rows.append(BRExcelRowModel(
        cells: [
            BRExcelCellModel(text: "UI设计"),
            BRExcelCellModel(text: "进行中")
        ],
        height: 80,
        customRowViewType: SimpleCardView.self
    ))
    
    // 3. 普通数据行
    rows.append(BRExcelRowModel(
        cells: [
            BRExcelCellModel(text: "开发任务", widthType: .flexible),
            BRExcelCellModel(text: "已完成", widthType: .fixed(80), textColor: .systemGreen)
        ],
        height: 44
    ))
    
    // 4. 自定义进度行
    rows.append(BRExcelRowModel(
        cells: [
            BRExcelCellModel(text: "测试"),
            BRExcelCellModel(text: "75")  // 进度值
        ],
        height: 70,
        customRowViewType: SimpleProgressView.self
    ))
    
    excelView.setData(rows: rows)
}

// MARK: - 简单的自定义行视图示例

/// 简单卡片视图
class SimpleCardView: UIView, BRExcelCustomRowView {
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textAlignment = .right
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        if model.cells.count >= 2 {
            titleLabel.text = "📋 " + model.cells[0].text
            statusLabel.text = model.cells[1].text
            statusLabel.textColor = model.cells[1].text == "进行中" ? .systemOrange : .systemGreen
        }
    }
}

/// 简单进度视图
class SimpleProgressView: UIView, BRExcelCustomRowView {
    private let nameLabel = UILabel()
    private let progressView = UIProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        nameLabel.font = .systemFont(ofSize: 15)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        progressView.progressTintColor = .systemBlue
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            progressView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        if model.cells.count >= 2 {
            nameLabel.text = model.cells[0].text
            if let value = Float(model.cells[1].text) {
                progressView.progress = value / 100.0
            }
        }
    }
}

/// 简单设置行视图
class SettingRowView: UIView, BRExcelCustomRowView {
    private let titleLabel = UILabel()
    private let switchControl = UISwitch()
    
    var onToggle: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        switchControl.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        if model.cells.count >= 2 {
            titleLabel.text = model.cells[0].text
            if let isOn = Bool(model.cells[1].text) {
                switchControl.isOn = isOn
            }
        }
    }
    
    @objc private func switchToggled() {
        onToggle?(switchControl.isOn)
    }
}

// MARK: - 完整的 ViewController 示例

class DemoViewController: UIViewController {
    
    private let excelView: BRExcelView = {
        let view = BRExcelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // 添加视图
        view.addSubview(excelView)
        NSLayoutConstraint.activate([
            excelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            excelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            excelView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
        
        // 选择一个示例运行
        // example1_SimpleTable(in: excelView)
        // example2_ColumnWidths(in: excelView)
        // example3_CustomStyle(in: excelView)
        // example4_CustomRowView(in: excelView)
        // example5_InteractiveRow(in: excelView)
        example6_MixedContent(in: excelView)
    }
}
