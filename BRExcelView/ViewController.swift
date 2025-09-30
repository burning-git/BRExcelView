//
//  ViewController.swift
//  BRExcelView
//
//  Created by git burning on 30.09.25.
//

import UIKit
import BRExcelView

class ViewController: UIViewController {
    
    private let excelView: BRExcelView = {
        let view = BRExcelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.enableAutoFit = false // 不自动填充，宽度由内容决定
//        view.maxHeight = 400 // 设置最大高度，超过则滚动
        
        // 添加边框和圆角
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "BRExcelView Demo"
        view.backgroundColor = .systemGroupedBackground
        
        setupNavigationBar()
        setupExcelView()
        loadSampleData()
    }
    
    private func setupNavigationBar() {
        // 添加示例按钮
        let examplesButton = UIBarButtonItem(
            title: "Examples",
            style: .plain,
            target: self,
            action: #selector(showExamples)
        )
        navigationItem.rightBarButtonItem = examplesButton
    }
    
    @objc private func showExamples() {
        let alertController = UIAlertController(
            title: "选择示例",
            message: "请先添加 BRExcelView Package 后查看更多示例\n详见: HOW_TO_USE_PACKAGE.md",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "知道了", style: .default))
        
        
        // TODO: 添加 Package 后取消下面代码的注释
        
        // 快速入门示例
        alertController.addAction(UIAlertAction(title: "📖 快速入门示例", style: .default) { _ in
            let vc = QuickStartExamplesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        // 自定义行视图示例
        alertController.addAction(UIAlertAction(title: "🎨 精美自定义行视图", style: .default) { _ in
            let vc = CustomRowExamplesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        // 真实场景示例
        alertController.addAction(UIAlertAction(title: "🏢 真实应用场景", style: .default) { _ in
            let vc = RealWorldExamplesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        present(alertController, animated: true)

    }
    
    private func setupExcelView() {
        view.addSubview(excelView)
        
        // 使用自适应宽度和高度，不固定 trailing 和 bottom 约束
        NSLayoutConstraint.activate([
            excelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            excelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            // 移除 trailingAnchor 约束，让宽度由内容决定
            // 移除 bottomAnchor 约束，让高度由内容决定
        ])
        
        // 可选：添加最大宽度约束，避免内容过宽
        excelView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func loadSampleData() {
        loadSampleDataSimple()
    }
    
    private func loadSampleDataSimple() {
        let header = ["", "Total", "Listening", "Reading"]
        
        let data: [[String]] = [
            ["PTE Core Score", "77", "78", "73"],
            ["CLB", "--", "78", "73"],
            ["IELTS(G) Equal", "--", "78", "73"],
            ["EE Pts (w/o Spouse)", "77", "78", "73"],
            ["EE Pts (w/Spouse)", "77", "78", "73"],
            ["EE Pts (as Spouse)", "77", "78", "73"]
        ]
        
        let columnWidthTypes: [BRExcelCellWidthType] = [
            .fixed(100),
            .fixed(50),
            .fixed(50),
            .fixed(50)
        ]
        
        excelView.setData(
            header: header,
            data: data,
            headerHeight: 50,
            rowHeight: 44,
            columnWidthTypes: columnWidthTypes
        )
    }
}

// 删除下面所有不需要的示例代码

/*
// 以下是其他示例方法，暂时不需要

    private func loadSampleDataWithModels() {
        var rows: [BRExcelRowModel] = []
        
        // 表头行
        let headerCells = [
            BRExcelCellModel(text: "", widthType: .fixed(120), backgroundColor: .systemGray5),
            BRExcelCellModel(text: "Total", widthType: .auto, backgroundColor: .systemGray5),
            BRExcelCellModel(text: "Listening", widthType: .auto, backgroundColor: .systemGray5),
            BRExcelCellModel(text: "Reading", widthType: .auto, backgroundColor: .systemGray5),
            BRExcelCellModel(text: "Speaking", widthType: .auto, backgroundColor: .systemGray5),
            BRExcelCellModel(text: "Writing", widthType: .auto, backgroundColor: .systemGray5)
        ]
        rows.append(BRExcelRowModel(cells: headerCells, height: 50, isHeader: true))
        
        // 数据行
        let dataRows = [
            ["PTE Core Score", "77", "78", "73", "73", "73"],
            ["CLB", "--", "78", "73", "73", "73"],
            ["IELTS(G) Equal", "--", "78", "73", "73", "73"],
            ["EE Pts (w/o Spouse)", "77", "78", "73", "73", "73"],
            ["EE Pts (w/Spouse)", "77", "78", "73", "73", "73"],
            ["EE Pts (as Spouse)", "77", "78", "73", "73", "73"]
        ]
        
        for rowData in dataRows {
            let cells = rowData.enumerated().map { index, text -> BRExcelCellModel in
                if index == 0 {
                    // 第一列：固定宽度120
                    return BRExcelCellModel(
                        text: text,
                        widthType: .fixed(120),
                        textAlignment: .left
                    )
                } else {
                    // 其他列：弹性宽度
                    return BRExcelCellModel(
                        text: text,
                        widthType: .flexible,
                        textAlignment: .center
                    )
                }
            }
            rows.append(BRExcelRowModel(cells: cells, height: 44))
        }
        
        excelView.setData(rows: rows)
    }
    
    // MARK: - 示例：加载长内容需要滚动的数据
    private func loadLongContentData() {
        let header = ["Name", "Email", "Phone", "Address", "City", "Country", "Postal Code", "Notes"]
        
        let data: [[String]] = [
            ["John Doe", "john.doe@example.com", "123-456-7890", "123 Main St", "New York", "USA", "10001", "VIP Customer"],
            ["Jane Smith", "jane.smith@example.com", "098-765-4321", "456 Oak Ave", "Los Angeles", "USA", "90001", "Regular Customer"],
            ["Bob Johnson", "bob.johnson@example.com", "555-123-4567", "789 Pine Rd", "Chicago", "USA", "60601", "New Customer"],
            ["Alice Brown", "alice.brown@example.com", "444-987-6543", "321 Elm St", "Houston", "USA", "77001", "Premium Member"],
            ["Charlie Wilson", "charlie.wilson@example.com", "333-222-1111", "654 Maple Dr", "Phoenix", "USA", "85001", "Standard Member"]
        ]
        
        // 配置不同的列宽类型
        let columnWidthTypes: [BRExcelCellWidthType] = [
            .fixed(100),  // Name: 固定100
            .auto,        // Email: 自适应内容
            .fixed(120),  // Phone: 固定120
            .auto,        // Address: 自适应内容
            .fixed(100),  // City: 固定100
            .fixed(80),   // Country: 固定80
            .fixed(100),  // Postal Code: 固定100
            .flexible     // Notes: 弹性宽度
        ]
        
        excelView.setData(
            header: header,
            data: data,
            columnWidthTypes: columnWidthTypes
        )
    }
    
    // MARK: - 示例：混合宽度类型
    private func loadMixedWidthData() {
        var rows: [BRExcelRowModel] = []
        
        // 表头
        let headerCells = [
            BRExcelCellModel(text: "ID", widthType: .fixed(60), backgroundColor: .systemGray5),
            BRExcelCellModel(text: "Name", widthType: .auto, minWidth: 100, backgroundColor: .systemGray5),
            BRExcelCellModel(text: "Score", widthType: .fixed(80), backgroundColor: .systemGray5),
            BRExcelCellModel(text: "Description", widthType: .flexible, backgroundColor: .systemGray5)
        ]
        rows.append(BRExcelRowModel(cells: headerCells, height: 50, isHeader: true))
        
        // 数据行
        let dataItems = [
            ["001", "Alice", "95", "Excellent performance"],
            ["002", "Bob", "87", "Good work"],
            ["003", "Charlie", "92", "Very good"]
        ]
        
        for item in dataItems {
            let cells = [
                BRExcelCellModel(text: item[0], widthType: .fixed(60)),
                BRExcelCellModel(text: item[1], widthType: .auto, minWidth: 100),
                BRExcelCellModel(text: item[2], widthType: .fixed(80)),
                BRExcelCellModel(text: item[3], widthType: .flexible)
            ]
            rows.append(BRExcelRowModel(cells: cells, height: 44))
        }
        
        excelView.setData(rows: rows)
    }
    
    // MARK: - 方式3: 自定义行视图示例
    // 注意：使用前需要先在 Xcode 中添加 BRExcelView Package
    // 详见 TROUBLESHOOTING.md 和 HOW_TO_USE_PACKAGE.md
    
    /*
    private func loadCustomRowViewExample() {
        var rows: [BRExcelRowModel] = []
        
        // 普通表头
        let headerCells = [
            BRExcelCellModel(text: "项目", widthType: .flexible, font: .boldSystemFont(ofSize: 16), backgroundColor: .systemBlue, textColor: .white, borderWidth: 0),
            BRExcelCellModel(text: "状态", widthType: .fixed(100), font: .boldSystemFont(ofSize: 16), backgroundColor: .systemBlue, textColor: .white, borderWidth: 0)
        ]
        rows.append(BRExcelRowModel(cells: headerCells, height: 50, isHeader: true))
        
        // 示例1: 使用自定义卡片式行视图
        let cardRow = BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "设计新功能"),
                BRExcelCellModel(text: "进行中"),
                BRExcelCellModel(text: "2024-12-31")
            ],
            height: 80,
            customRowViewType: CardStyleRowView.self
        )
        rows.append(cardRow)
        
        // 示例2: 使用自定义进度条行视图
        let progressRow = BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "开发任务"),
                BRExcelCellModel(text: "75")  // 进度值
            ],
            height: 70,
            customRowViewType: ProgressRowView.self
        )
        rows.append(progressRow)
        
        // 示例3: 使用自定义可交互行视图
        let interactiveRow = BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "启用推送通知"),
                BRExcelCellModel(text: "true")
            ],
            height: 60,
            customRowViewType: InteractiveRowView.self,
            customRowViewConfiguration: { view, model, _ in
                guard let interactiveView = view as? InteractiveRowView else { return }
                
                interactiveView.onSwitchToggle = { isOn in
                    print("通知开关切换为: \(isOn)")
                }
                
                interactiveView.onButtonTap = {
                    print("设置按钮被点击")
                }
            }
        )
        rows.append(interactiveRow)
        
        // 普通行（混合使用）
        let normalRow = BRExcelRowModel(
            cells: [
                BRExcelCellModel(text: "文档编写", widthType: .flexible),
                BRExcelCellModel(text: "已完成", widthType: .fixed(100), textColor: .systemGreen)
            ],
            height: 44
        )
        rows.append(normalRow)
        
        excelView.setData(rows: rows)
    }
    */
}

/*
// MARK: - 自定义行视图示例
// 注意：这些示例需要先添加 BRExcelView Package 才能使用
// 详细步骤请查看 TROUBLESHOOTING.md

/// 示例1: 卡片式行视图
class CardStyleRowView: UIView, BRExcelCustomRowView {
    
    private let cardContainer = UIView()
    private let titleLabel = UILabel()
    private let statusBadge = UILabel()
    private let dateLabel = UILabel()
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
        backgroundColor = .clear
        
        // 卡片容器
        cardContainer.backgroundColor = .white
        cardContainer.layer.cornerRadius = 8
        cardContainer.layer.borderWidth = 1
        cardContainer.layer.borderColor = UIColor.systemGray5.cgColor
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardContainer)
        
        // 图标
        iconView.image = UIImage(systemName: "folder.fill")
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(iconView)
        
        // 标题
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(titleLabel)
        
        // 日期
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .systemGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(dateLabel)
        
        // 状态徽章
        statusBadge.font = .systemFont(ofSize: 12, weight: .medium)
        statusBadge.textAlignment = .center
        statusBadge.layer.cornerRadius = 4
        statusBadge.clipsToBounds = true
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(statusBadge)
        
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cardContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            cardContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cardContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            iconView.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadge.leadingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            statusBadge.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            statusBadge.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -12),
            statusBadge.widthAnchor.constraint(equalToConstant: 70),
            statusBadge.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        guard model.cells.count >= 2 else { return }
        
        titleLabel.text = model.cells[0].text
        
        let status = model.cells[1].text
        statusBadge.text = status
        
        switch status {
        case "进行中":
            statusBadge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
            statusBadge.textColor = .systemOrange
        case "已完成":
            statusBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            statusBadge.textColor = .systemGreen
        default:
            statusBadge.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            statusBadge.textColor = .systemGray
        }
        
        if model.cells.count > 2 {
            dateLabel.text = "📅 " + model.cells[2].text
        }
    }
}

/// 示例2: 进度条行视图
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
        backgroundColor = .white
        
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
        
        percentLabel.font = .systemFont(ofSize: 14, weight: .bold)
        percentLabel.textColor = .systemBlue
        percentLabel.textAlignment = .right
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: percentLabel.leadingAnchor, constant: -8),
            
            percentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            percentLabel.widthAnchor.constraint(equalToConstant: 50),
            
            progressView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 8)
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
                percentLabel.textColor = .systemGreen
            } else if progress >= 0.5 {
                progressView.progressTintColor = .systemOrange
                percentLabel.textColor = .systemOrange
            } else {
                progressView.progressTintColor = .systemRed
                percentLabel.textColor = .systemRed
            }
        }
    }
}

/// 示例3: 可交互行视图
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
        
        actionButton.setTitle("设置", for: .normal)
        actionButton.setImage(UIImage(systemName: "gear"), for: .normal)
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
        
        if model.cells.count > 1, let isOn = Bool(model.cells[1].text) {
            switchControl.isOn = isOn
        }
    }
    
    @objc private func buttonTapped() {
        onButtonTap?()
    }
    
    @objc private func switchToggled() {
        onSwitchToggle?(switchControl.isOn)
    }
}
 */*/
