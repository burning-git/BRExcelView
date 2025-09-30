//
//  CustomRowExamplesViewController.swift
//  精美自定义行视图示例页面
//

import UIKit
import BRExcelView

class CustomRowExamplesViewController: UIViewController {
    
    private let excelView: BRExcelView = {
        let view = BRExcelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "精美自定义行视图"
        view.backgroundColor = .systemGroupedBackground
        
        setupUI()
        loadExamples()
    }
    
    private func setupUI() {
        view.addSubview(excelView)
        
        NSLayoutConstraint.activate([
            excelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            excelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            excelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func loadExamples() {
        var rows: [BRExcelRowModel] = []
        
        // 表头
        let headerCells = [
            BRExcelCellModel(
                text: "项目管理面板",
                widthType: .flexible,
                font: .boldSystemFont(ofSize: 18),
                textColor: .white,
                backgroundColor: .systemIndigo,
                borderWidth: 0
            )
        ]
        rows.append(BRExcelRowModel(cells: headerCells, height: 50, isHeader: true))
        
        // 任务卡片行
        rows.append(createTaskCard(title: "UI设计优化", status: "进行中", deadline: "2024-12-15", priority: "高"))
        rows.append(createTaskCard(title: "API接口开发", status: "已完成", deadline: "2024-11-30", priority: "中"))
        
        // 进度条行
        rows.append(createProgressRow(name: "前端开发", progress: 85))
        rows.append(createProgressRow(name: "后端开发", progress: 45))
        
        // 可交互行
        rows.append(createInteractiveRow(title: "推送通知", isEnabled: true))
        rows.append(createInteractiveRow(title: "自动备份", isEnabled: false))
        
        excelView.setData(rows: rows)
    }
    
    private func createTaskCard(title: String, status: String, deadline: String, priority: String) -> BRExcelRowModel {
        let cells = [
            BRExcelCellModel(text: title),
            BRExcelCellModel(text: status),
            BRExcelCellModel(text: deadline),
            BRExcelCellModel(text: priority)
        ]
        return BRExcelRowModel(
            cells: cells,
            height: 90,
            customRowViewType: DemoTaskCardRowView.self
        )
    }
    
    private func createProgressRow(name: String, progress: Int) -> BRExcelRowModel {
        let cells = [
            BRExcelCellModel(text: name),
            BRExcelCellModel(text: "\(progress)")
        ]
        return BRExcelRowModel(
            cells: cells,
            height: 70,
            customRowViewType: DemoProgressRowView.self
        )
    }
    
    private func createInteractiveRow(title: String, isEnabled: Bool) -> BRExcelRowModel {
        let cells = [
            BRExcelCellModel(text: title),
            BRExcelCellModel(text: "\(isEnabled)")
        ]
        return BRExcelRowModel(
            cells: cells,
            height: 60,
            customRowViewType: DemoInteractiveRowView.self,
            customRowViewConfiguration: { view, model, _ in
                guard let interactiveView = view as? DemoInteractiveRowView else { return }
                
                interactiveView.onSwitchToggle = { isOn in
                    print("[\(title)] 开关状态: \(isOn ? "开启" : "关闭")")
                }
                
                interactiveView.onButtonTap = {
                    print("[\(title)] 设置按钮被点击")
                }
            }
        )
    }
}

// MARK: - 自定义行视图（从 CustomRowViewExamples.swift 简化版本）

class DemoTaskCardRowView: UIView, BRExcelCustomRowView {
    
    private let cardContainer = UIView()
    private let titleLabel = UILabel()
    private let statusBadge = UILabel()
    private let deadlineLabel = UILabel()
    private let priorityIndicator = UIView()
    
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
        
        cardContainer.backgroundColor = .white
        cardContainer.layer.cornerRadius = 8
        cardContainer.layer.borderWidth = 1
        cardContainer.layer.borderColor = UIColor.systemGray5.cgColor
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardContainer)
        
        priorityIndicator.layer.cornerRadius = 2
        priorityIndicator.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(priorityIndicator)
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(titleLabel)
        
        deadlineLabel.font = .systemFont(ofSize: 12)
        deadlineLabel.textColor = .secondaryLabel
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(deadlineLabel)
        
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
            
            priorityIndicator.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor),
            priorityIndicator.topAnchor.constraint(equalTo: cardContainer.topAnchor),
            priorityIndicator.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor),
            priorityIndicator.widthAnchor.constraint(equalToConstant: 4),
            
            titleLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: priorityIndicator.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadge.leadingAnchor, constant: -8),
            
            deadlineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            deadlineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            statusBadge.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            statusBadge.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -12),
            statusBadge.widthAnchor.constraint(equalToConstant: 70),
            statusBadge.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        guard model.cells.count >= 4 else { return }
        
        titleLabel.text = model.cells[0].text
        
        let status = model.cells[1].text
        statusBadge.text = status
        switch status {
        case "进行中":
            statusBadge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
            statusBadge.textColor = .systemOrange
        case "已完成":
            statusBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            statusBadge.textColor = .systemGreen
        default:
            statusBadge.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
            statusBadge.textColor = .systemBlue
        }
        
        deadlineLabel.text = "📅 " + model.cells[2].text
        
        let priority = model.cells[3].text
        switch priority {
        case "高":
            priorityIndicator.backgroundColor = .systemRed
        case "中":
            priorityIndicator.backgroundColor = .systemOrange
        case "低":
            priorityIndicator.backgroundColor = .systemGreen
        default:
            priorityIndicator.backgroundColor = .systemGray
        }
    }
}

class DemoProgressRowView: UIView, BRExcelCustomRowView {
    
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let progressView = UIProgressView()
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
        
        containerView.backgroundColor = .systemGray6.withAlphaComponent(0.3)
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressView)
        
        percentLabel.font = .systemFont(ofSize: 15, weight: .bold)
        percentLabel.textAlignment = .right
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(percentLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            percentLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            percentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            percentLabel.widthAnchor.constraint(equalToConstant: 50),
            
            progressView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
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
            
            if progress >= 0.8 {
                progressView.progressTintColor = .systemGreen
                progressView.trackTintColor = UIColor.systemGreen.withAlphaComponent(0.2)
                percentLabel.textColor = .systemGreen
            } else if progress >= 0.5 {
                progressView.progressTintColor = .systemOrange
                progressView.trackTintColor = UIColor.systemOrange.withAlphaComponent(0.2)
                percentLabel.textColor = .systemOrange
            } else {
                progressView.progressTintColor = .systemRed
                progressView.trackTintColor = UIColor.systemRed.withAlphaComponent(0.2)
                percentLabel.textColor = .systemRed
            }
        }
    }
}

class DemoInteractiveRowView: UIView, BRExcelCustomRowView {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
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
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitleLabel)
        
        actionButton.setImage(UIImage(systemName: "gear"), for: .normal)
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        
        switchControl.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -12)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        if let text = model.cells.first?.text {
            titleLabel.text = text
            subtitleLabel.text = text.contains("通知") ? "接收应用推送消息" : "自动同步到 iCloud"
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
