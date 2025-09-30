//
//  CustomRowViewExamples.swift
//  BRExcelView Custom Row View Examples
//
//  这个文件展示了如何创建和使用自定义行视图
//  注意：使用前需要先在 Xcode 中添加 BRExcelView Package
//

import UIKit
import BRExcelView

// MARK: - 使用示例

/// 在 ViewController 中使用自定义行视图的完整示例
class ExampleViewController: UIViewController {
    
    private let excelView: BRExcelView = {
        let view = BRExcelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadExamples()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(excelView)
        
        NSLayoutConstraint.activate([
            excelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            excelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            excelView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func loadExamples() {
        var rows: [BRExcelRowModel] = []
        
        // 1. 普通表头
        rows.append(createHeader())
        
        // 2. 卡片式任务行
        rows.append(createTaskCard(title: "UI设计优化", status: "进行中", deadline: "2024-12-15", priority: "高"))
        rows.append(createTaskCard(title: "API接口开发", status: "已完成", deadline: "2024-11-30", priority: "中"))
        
        // 3. 进度条任务行
        rows.append(createProgressRow(name: "前端开发", progress: 85))
        rows.append(createProgressRow(name: "后端开发", progress: 45))
        rows.append(createProgressRow(name: "测试任务", progress: 20))
        
        // 4. 可交互设置行
        rows.append(createInteractiveRow(title: "推送通知", isEnabled: true))
        rows.append(createInteractiveRow(title: "自动备份", isEnabled: false))
        
        // 5. 用户信息卡片行
        rows.append(createUserCard(name: "张三", role: "iOS开发工程师", avatar: "person.circle.fill"))
        rows.append(createUserCard(name: "李四", role: "UI设计师", avatar: "paintbrush.fill"))
        
        excelView.setData(rows: rows)
    }
    
    // MARK: - 创建各种类型的行
    
    private func createHeader() -> BRExcelRowModel {
        let cells = [
            BRExcelCellModel(
                text: "项目管理面板",
                widthType: .flexible,
                font: .boldSystemFont(ofSize: 18),
                backgroundColor: .systemIndigo,
                textColor: .white,
                borderWidth: 0
            )
        ]
        return BRExcelRowModel(cells: cells, height: 50, isHeader: true)
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
            customRowViewType: TaskCardRowView.self
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
            customRowViewType: ProgressRowView.self
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
            customRowViewType: InteractiveRowView.self,
            customRowViewConfiguration: { view, model, _ in
                guard let interactiveView = view as? InteractiveRowView else { return }
                
                interactiveView.onSwitchToggle = { isOn in
                    print("[\(title)] 开关状态: \(isOn ? "开启" : "关闭")")
                }
                
                interactiveView.onButtonTap = {
                    print("[\(title)] 设置按钮被点击")
                    // 这里可以弹出详细设置页面
                }
            }
        )
    }
    
    private func createUserCard(name: String, role: String, avatar: String) -> BRExcelRowModel {
        let cells = [
            BRExcelCellModel(text: name),
            BRExcelCellModel(text: role),
            BRExcelCellModel(text: avatar)
        ]
        return BRExcelRowModel(
            cells: cells,
            height: 80,
            customRowViewType: UserCardRowView.self
        )
    }
}

// MARK: - 自定义行视图 1: 任务卡片

class TaskCardRowView: UIView, BRExcelCustomRowView {
    
    private let cardContainer = UIView()
    private let titleLabel = UILabel()
    private let statusBadge = UILabel()
    private let deadlineLabel = UILabel()
    private let priorityIndicator = UIView()
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
        
        // 卡片容器 - 带阴影效果
        cardContainer.backgroundColor = .white
        cardContainer.layer.cornerRadius = 12
        cardContainer.layer.borderWidth = 1
        cardContainer.layer.borderColor = UIColor.systemGray5.cgColor
        cardContainer.layer.shadowColor = UIColor.black.cgColor
        cardContainer.layer.shadowOpacity = 0.1
        cardContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardContainer.layer.shadowRadius = 4
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardContainer)
        
        // 优先级指示器（左侧彩色条）
        priorityIndicator.layer.cornerRadius = 2
        priorityIndicator.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(priorityIndicator)
        
        // 图标
        iconView.image = UIImage(systemName: "checklist")
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(iconView)
        
        // 标题
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(titleLabel)
        
        // 截止日期
        deadlineLabel.font = .systemFont(ofSize: 13)
        deadlineLabel.textColor = .secondaryLabel
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(deadlineLabel)
        
        // 状态徽章
        statusBadge.font = .systemFont(ofSize: 12, weight: .semibold)
        statusBadge.textAlignment = .center
        statusBadge.layer.cornerRadius = 6
        statusBadge.clipsToBounds = true
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(statusBadge)
        
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            cardContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            cardContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cardContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            priorityIndicator.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor),
            priorityIndicator.topAnchor.constraint(equalTo: cardContainer.topAnchor),
            priorityIndicator.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor),
            priorityIndicator.widthAnchor.constraint(equalToConstant: 4),
            
            iconView.leadingAnchor.constraint(equalTo: priorityIndicator.trailingAnchor, constant: 12),
            iconView.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadge.leadingAnchor, constant: -12),
            
            deadlineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            deadlineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            statusBadge.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            statusBadge.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            statusBadge.widthAnchor.constraint(equalToConstant: 80),
            statusBadge.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        guard model.cells.count >= 4 else { return }
        
        // 标题
        titleLabel.text = model.cells[0].text
        
        // 状态
        let status = model.cells[1].text
        statusBadge.text = status
        switch status {
        case "进行中":
            statusBadge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
            statusBadge.textColor = .systemOrange
        case "已完成":
            statusBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            statusBadge.textColor = .systemGreen
        case "待开始":
            statusBadge.backgroundColor = UIColor.systemGray.withAlphaComponent(0.15)
            statusBadge.textColor = .systemGray
        default:
            statusBadge.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
            statusBadge.textColor = .systemBlue
        }
        
        // 截止日期
        deadlineLabel.text = "📅 截止: " + model.cells[2].text
        
        // 优先级
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

// MARK: - 自定义行视图 2: 进度条

class ProgressRowView: UIView, BRExcelCustomRowView {
    
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let percentLabel = UILabel()
    private let statusIcon = UIImageView()
    
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
        
        statusIcon.contentMode = .scaleAspectFit
        statusIcon.tintColor = .systemBlue
        statusIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusIcon)
        
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        nameLabel.textColor = .label
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
            
            statusIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            statusIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            statusIcon.widthAnchor.constraint(equalToConstant: 24),
            statusIcon.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.centerYAnchor.constraint(equalTo: statusIcon.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: statusIcon.trailingAnchor, constant: 8),
            
            percentLabel.centerYAnchor.constraint(equalTo: statusIcon.centerYAnchor),
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
            
            // 根据进度设置颜色和图标
            if progress >= 0.8 {
                progressView.progressTintColor = .systemGreen
                progressView.trackTintColor = UIColor.systemGreen.withAlphaComponent(0.2)
                percentLabel.textColor = .systemGreen
                statusIcon.image = UIImage(systemName: "checkmark.circle.fill")
                statusIcon.tintColor = .systemGreen
            } else if progress >= 0.5 {
                progressView.progressTintColor = .systemOrange
                progressView.trackTintColor = UIColor.systemOrange.withAlphaComponent(0.2)
                percentLabel.textColor = .systemOrange
                statusIcon.image = UIImage(systemName: "clock.fill")
                statusIcon.tintColor = .systemOrange
            } else {
                progressView.progressTintColor = .systemRed
                progressView.trackTintColor = UIColor.systemRed.withAlphaComponent(0.2)
                percentLabel.textColor = .systemRed
                statusIcon.image = UIImage(systemName: "exclamationmark.triangle.fill")
                statusIcon.tintColor = .systemRed
            }
        }
    }
}

// MARK: - 自定义行视图 3: 可交互行

class InteractiveRowView: UIView, BRExcelCustomRowView {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let switchControl = UISwitch()
    private let iconView = UIImageView()
    
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
        
        // 图标
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        // 标题
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // 副标题
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitleLabel)
        
        // 按钮
        actionButton.setImage(UIImage(systemName: "gear"), for: .normal)
        actionButton.tintColor = .systemGray
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        
        // 开关
        switchControl.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -12),
            actionButton.widthAnchor.constraint(equalToConstant: 44),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        if let text = model.cells.first?.text {
            titleLabel.text = text
            
            // 根据标题设置图标和副标题
            if text.contains("通知") {
                iconView.image = UIImage(systemName: "bell.fill")
                subtitleLabel.text = "接收应用推送消息"
            } else if text.contains("备份") {
                iconView.image = UIImage(systemName: "icloud.fill")
                subtitleLabel.text = "自动同步到 iCloud"
            } else {
                iconView.image = UIImage(systemName: "gearshape.fill")
                subtitleLabel.text = "配置相关设置"
            }
        }
        
        if model.cells.count > 1, let isOn = Bool(model.cells[1].text) {
            switchControl.isOn = isOn
        }
    }
    
    @objc private func buttonTapped() {
        // 添加点击动画
        UIView.animate(withDuration: 0.1, animations: {
            self.actionButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.actionButton.transform = .identity
            }
        }
        onButtonTap?()
    }
    
    @objc private func switchToggled() {
        onSwitchToggle?(switchControl.isOn)
    }
}

// MARK: - 自定义行视图 4: 用户信息卡片

class UserCardRowView: UIView, BRExcelCustomRowView {
    
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let roleLabel = UILabel()
    private let badgeLabel = UILabel()
    private let arrowIcon = UIImageView()
    
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
        
        // 头像
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 30
        avatarView.backgroundColor = .systemGray5
        avatarView.tintColor = .systemBlue
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarView)
        
        // 姓名
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        // 角色
        roleLabel.font = .systemFont(ofSize: 14)
        roleLabel.textColor = .secondaryLabel
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(roleLabel)
        
        // 徽章
        badgeLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        badgeLabel.textAlignment = .center
        badgeLabel.text = "VIP"
        badgeLabel.textColor = .systemOrange
        badgeLabel.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
        badgeLabel.layer.cornerRadius = 4
        badgeLabel.clipsToBounds = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(badgeLabel)
        
        // 箭头
        arrowIcon.image = UIImage(systemName: "chevron.right")
        arrowIcon.tintColor = .systemGray3
        arrowIcon.contentMode = .scaleAspectFit
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrowIcon)
        
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            
            badgeLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            badgeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            badgeLabel.widthAnchor.constraint(equalToConstant: 36),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            roleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowIcon.widthAnchor.constraint(equalToConstant: 12),
            arrowIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        guard model.cells.count >= 3 else { return }
        
        nameLabel.text = model.cells[0].text
        roleLabel.text = model.cells[1].text
        
        // 设置头像图标
        let iconName = model.cells[2].text
        avatarView.image = UIImage(systemName: iconName)
    }
}
