//
//  QuickStartExamplesViewController.swift
//  快速入门示例页面
//

import UIKit
import BRExcelView

class QuickStartExamplesViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    private let examples = [
        ("示例 1: 最简单的表格", "3 行代码创建基础表格"),
        ("示例 2: 配置列宽", "固定、自适应、弹性宽度"),
        ("示例 3: 自定义样式", "颜色、字体、边框"),
        ("示例 4: 自定义行视图", "简单卡片布局"),
        ("示例 5: 可交互行", "开关和按钮"),
        ("示例 6: 混合使用", "多种类型组合")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "快速入门示例"
        view.backgroundColor = .systemGroupedBackground
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension QuickStartExamplesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let example = examples[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = example.0
        config.secondaryText = example.1
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = ExampleDetailViewController()
        detailVC.title = examples[indexPath.row].0
        
        // 根据不同示例加载不同数据
        switch indexPath.row {
        case 0:
            detailVC.loadExample = { excelView in
                self.example1_SimpleTable(in: excelView)
            }
        case 1:
            detailVC.loadExample = { excelView in
                self.example2_ColumnWidths(in: excelView)
            }
        case 2:
            detailVC.loadExample = { excelView in
                self.example3_CustomStyle(in: excelView)
            }
        case 3:
            detailVC.loadExample = { excelView in
                self.example4_CustomRowView(in: excelView)
            }
        case 4:
            detailVC.loadExample = { excelView in
                self.example5_InteractiveRow(in: excelView)
            }
        case 5:
            detailVC.loadExample = { excelView in
                self.example6_MixedContent(in: excelView)
            }
        default:
            break
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - 示例方法（从 QuickStartGuide.swift 复制）

extension QuickStartExamplesViewController {
    
    func example1_SimpleTable(in excelView: BRExcelView) {
        let header = ["姓名", "年龄", "城市"]
        let data = [
            ["张三", "25", "北京"],
            ["李四", "30", "上海"],
            ["王五", "28", "深圳"]
        ]
        excelView.setData(header: header, data: data)
    }
    
    func example2_ColumnWidths(in excelView: BRExcelView) {
        let header = ["姓名", "分数", "等级"]
        let data = [
            ["张三", "95", "A"],
            ["李四", "88", "B"],
            ["王五", "92", "A-"]
        ]
        let columnWidths: [BRExcelCellWidthType] = [.auto, .fixed(100), .fixed(60)]
        excelView.setData(header: header, data: data, columnWidthTypes: columnWidths)
    }
    
    func example3_CustomStyle(in excelView: BRExcelView) {
        var rows: [BRExcelRowModel] = []
        
        let headerRow = BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "科目", widthType: .auto, textColor: .white, backgroundColor: .systemBlue),
                BRExcelCellModel(text: "成绩", widthType: .fixed(80), textColor: .white, backgroundColor: .systemBlue)
            ],
            height: 50,
            isHeader: true
        )
        rows.append(headerRow)
        
        let dataRow = BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "数学", widthType: .auto),
                BRExcelCellModel(text: "95", widthType: .fixed(80), font: .boldSystemFont(ofSize: 16), textColor: .systemGreen)
            ],
            height: 44
        )
        rows.append(dataRow)
        
        excelView.setData(rows: rows)
    }
    
    func example4_CustomRowView(in excelView: BRExcelView) {
        var rows: [BRExcelRowModel] = []
        
        let header = BRExcelRowModel(
            cells: [BRExcelCellModel(text: "任务列表", widthType: .flexible, textColor: .white, backgroundColor: .systemIndigo)],
            height: 50,
            isHeader: true
        )
        rows.append(header)
        
        let cardRow = BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "完成项目文档"),
                BRExcelCellModel(text: "进行中")
            ],
            height: 80,
            customRowViewType: QuickStartSimpleCardView.self
        )
        rows.append(cardRow)
        
        excelView.setData(rows: rows)
    }
    
    func example5_InteractiveRow(in excelView: BRExcelView) {
        var rows: [BRExcelRowModel] = []
        
        let header = BRExcelRowModel(
            cells: [BRExcelCellModel(text: "设置", widthType: .flexible, textColor: .white, backgroundColor: .systemGreen)],
            height: 50,
            isHeader: true
        )
        rows.append(header)
        
        let interactiveRow = BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "启用通知"),
                BRExcelCellModel(text: "true")
            ],
            height: 60,
            customRowViewType: QuickStartSettingRowView.self,
            customRowViewConfiguration: { view, model, _ in
                if let settingView = view as? QuickStartSettingRowView {
                    settingView.onToggle = { isOn in
                        print("通知开关: \(isOn)")
                    }
                }
            }
        )
        rows.append(interactiveRow)
        
        excelView.setData(rows: rows)
    }
    
    func example6_MixedContent(in excelView: BRExcelView) {
        var rows: [BRExcelRowModel] = []
        
        rows.append(BRExcelRowModel(
            cells: [BRExcelCellModel(text: "项目管理", widthType: .flexible, textColor: .white, backgroundColor: .systemOrange)],
            height: 50,
            isHeader: true
        ))
        
        rows.append(BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "UI设计"),
                BRExcelCellModel(text: "进行中")
            ],
            height: 80,
            customRowViewType: QuickStartSimpleCardView.self
        ))
        
        rows.append(BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "开发任务", widthType: .flexible),
                BRExcelCellModel(text: "已完成", widthType: .fixed(80), textColor: .systemGreen)
            ],
            height: 44
        ))
        
        excelView.setData(rows: rows)
    }
}

// MARK: - 简单的自定义行视图

class QuickStartSimpleCardView: UIView, BRExcelCustomRowView {
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

class QuickStartSettingRowView: UIView, BRExcelCustomRowView {
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

// MARK: - 示例详情页面

class ExampleDetailViewController: UIViewController {
    
    var loadExample: ((BRExcelView) -> Void)?
    
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
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(excelView)
        NSLayoutConstraint.activate([
            excelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            excelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            excelView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
        
        loadExample?(excelView)
    }
}
