//
//  RealWorldExamplesViewController.swift
//  真实应用场景示例列表
//

import UIKit
import BRExcelView

class RealWorldExamplesViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    private let examples = [
        ("📊 成绩单", "学生成绩展示系统"),
        ("📦 订单列表", "电商订单管理"),
        ("📈 项目进度", "项目管理看板")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "真实应用场景"
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

extension RealWorldExamplesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let vc: UIViewController
        
        switch indexPath.row {
        case 0:
            vc = DemoScoreCardViewController()
        case 1:
            vc = DemoOrderListViewController()
        case 2:
            vc = DemoProjectTrackerViewController()
        default:
            return
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 场景 1: 成绩单

class DemoScoreCardViewController: UIViewController {
    
    private let excelView = BRExcelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadScoreData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "成绩单"
        
        excelView.translatesAutoresizingMaskIntoConstraints = false
        excelView.layer.cornerRadius = 12
        excelView.layer.borderWidth = 1
        excelView.layer.borderColor = UIColor.systemGray5.cgColor
        excelView.clipsToBounds = true
        view.addSubview(excelView)
        
        NSLayoutConstraint.activate([
            excelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            excelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            excelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func loadScoreData() {
        let header = ["科目", "分数", "等级", "排名"]
        let data = [
            ["数学", "95", "A", "5/120"],
            ["英语", "88", "B+", "15/120"],
            ["物理", "92", "A-", "8/120"],
            ["化学", "98", "A+", "2/120"],
            ["总分", "373", "优秀", "6/120"]
        ]
        
        let columnWidths: [BRExcelCellWidthType] = [
            .auto,
            .fixed(80),
            .fixed(60),
            .flexible
        ]
        
        excelView.setData(
            header: header,
            data: data,
            headerHeight: 50,
            rowHeight: 44,
            columnWidthTypes: columnWidths
        )
    }
}

// MARK: - 场景 2: 订单列表

class DemoOrderListViewController: UIViewController {
    
    private let excelView = BRExcelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadOrders()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "我的订单"
        
        excelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(excelView)
        
        NSLayoutConstraint.activate([
            excelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            excelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            excelView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadOrders() {
        var rows: [BRExcelRowModel] = []
        
        let headerCells = [
            BRExcelCellModel(
                text: "我的订单",
                widthType: .flexible,
                font: .boldSystemFont(ofSize: 20),
                textColor: .label,
                backgroundColor: .white,
                borderWidth: 0
            )
        ]
        rows.append(BRExcelRowModel(cells: headerCells, height: 60, isHeader: true))
        
        rows.append(createOrderRow(
            orderNumber: "202412010001",
            productName: "iPhone 15 Pro Max 256GB",
            price: "¥9999",
            status: "待发货",
            date: "2024-12-01"
        ))
        
        rows.append(createOrderRow(
            orderNumber: "202411280005",
            productName: "AirPods Pro (第二代)",
            price: "¥1999",
            status: "已完成",
            date: "2024-11-28"
        ))
        
        rows.append(createOrderRow(
            orderNumber: "202411250012",
            productName: "Apple Watch Series 9",
            price: "¥3199",
            status: "已取消",
            date: "2024-11-25"
        ))
        
        excelView.setData(rows: rows)
    }
    
    private func createOrderRow(orderNumber: String, productName: String, price: String, status: String, date: String) -> BRExcelRowModel {
        let cells = [
            BRExcelCellModel(text: orderNumber),
            BRExcelCellModel(text: productName),
            BRExcelCellModel(text: price),
            BRExcelCellModel(text: status),
            BRExcelCellModel(text: date)
        ]
        
        return BRExcelRowModel(
            cells: cells,
            height: 100,
            customRowViewType: DemoOrderCardView.self,
            customRowViewConfiguration: { view, model, _ in
                if let orderView = view as? DemoOrderCardView {
                    orderView.onTapOrder = {
                        print("查看订单详情: \(orderNumber)")
                    }
                }
            }
        )
    }
}

class DemoOrderCardView: UIView, BRExcelCustomRowView {
    
    private let containerView = UIView()
    private let productNameLabel = UILabel()
    private let orderNumberLabel = UILabel()
    private let priceLabel = UILabel()
    private let statusBadge = UILabel()
    private let dateLabel = UILabel()
    
    var onTapOrder: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.separator.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tapGesture)
        
        productNameLabel.font = .boldSystemFont(ofSize: 16)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(productNameLabel)
        
        orderNumberLabel.font = .systemFont(ofSize: 12)
        orderNumberLabel.textColor = .secondaryLabel
        orderNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(orderNumberLabel)
        
        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textColor = .systemRed
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(priceLabel)
        
        statusBadge.font = .systemFont(ofSize: 12, weight: .medium)
        statusBadge.textAlignment = .center
        statusBadge.layer.cornerRadius = 4
        statusBadge.clipsToBounds = true
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusBadge)
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            productNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            productNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            productNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadge.leadingAnchor, constant: -8),
            
            orderNumberLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 6),
            orderNumberLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            dateLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 12),
            
            statusBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            statusBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            statusBadge.widthAnchor.constraint(equalToConstant: 60),
            statusBadge.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        guard model.cells.count >= 5 else { return }
        
        orderNumberLabel.text = "订单号: " + model.cells[0].text
        productNameLabel.text = model.cells[1].text
        priceLabel.text = model.cells[2].text
        
        let status = model.cells[3].text
        statusBadge.text = status
        
        switch status {
        case "待发货":
            statusBadge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
            statusBadge.textColor = .systemOrange
        case "已完成":
            statusBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            statusBadge.textColor = .systemGreen
        case "已取消":
            statusBadge.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            statusBadge.textColor = .systemGray
        default:
            statusBadge.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
            statusBadge.textColor = .systemBlue
        }
        
        dateLabel.text = model.cells[4].text
    }
    
    @objc private func handleTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.containerView.transform = .identity
            }
        }
        onTapOrder?()
    }
}

// MARK: - 场景 3: 项目进度

class DemoProjectTrackerViewController: UIViewController {
    
    private let excelView = BRExcelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProjects()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "项目进度"
        
        excelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(excelView)
        
        NSLayoutConstraint.activate([
            excelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            excelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            excelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func loadProjects() {
        var rows: [BRExcelRowModel] = []
        
        rows.append(BRExcelRowModel(
            cells: [BRExcelCellModel(
                text: "项目进度跟踪",
                widthType: .flexible,
                font: .boldSystemFont(ofSize: 20),
                textColor: .white,
                backgroundColor: .systemIndigo,
                borderWidth: 0
            )],
            height: 60,
            isHeader: true
        ))
        
        let projects = [
            ("App UI 重构", 85, "张三", "2024-12-15"),
            ("后端API开发", 60, "李四", "2024-12-20"),
            ("数据库优化", 30, "王五", "2024-12-25"),
            ("测试用例编写", 45, "赵六", "2024-12-18")
        ]
        
        for project in projects {
            rows.append(createProjectRow(
                name: project.0,
                progress: project.1,
                owner: project.2,
                deadline: project.3
            ))
        }
        
        excelView.setData(rows: rows)
    }
    
    private func createProjectRow(name: String, progress: Int, owner: String, deadline: String) -> BRExcelRowModel {
        let cells = [
            BRExcelCellModel(text: name),
            BRExcelCellModel(text: "\(progress)"),
            BRExcelCellModel(text: owner),
            BRExcelCellModel(text: deadline)
        ]
        
        return BRExcelRowModel(
            cells: cells,
            height: 90,
            customRowViewType: DemoProjectProgressView.self
        )
    }
}

class DemoProjectProgressView: UIView, BRExcelCustomRowView {
    
    private let nameLabel = UILabel()
    private let ownerLabel = UILabel()
    private let deadlineLabel = UILabel()
    private let progressView = UIProgressView()
    private let percentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        ownerLabel.font = .systemFont(ofSize: 13)
        ownerLabel.textColor = .secondaryLabel
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ownerLabel)
        
        deadlineLabel.font = .systemFont(ofSize: 12)
        deadlineLabel.textColor = .tertiaryLabel
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deadlineLabel)
        
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
        
        percentLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .bold)
        percentLabel.textAlignment = .right
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            percentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            percentLabel.widthAnchor.constraint(equalToConstant: 50),
            
            ownerLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ownerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            deadlineLabel.centerYAnchor.constraint(equalTo: ownerLabel.centerYAnchor),
            deadlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            progressView.topAnchor.constraint(equalTo: ownerLabel.bottomAnchor, constant: 12),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        guard model.cells.count >= 4 else { return }
        
        nameLabel.text = model.cells[0].text
        ownerLabel.text = "👤 " + model.cells[2].text
        deadlineLabel.text = "📅 " + model.cells[3].text
        
        if let progress = Float(model.cells[1].text) {
            let progressValue = progress / 100.0
            progressView.progress = progressValue
            percentLabel.text = "\(Int(progress))%"
            
            if progressValue >= 0.8 {
                progressView.progressTintColor = .systemGreen
                progressView.trackTintColor = UIColor.systemGreen.withAlphaComponent(0.2)
                percentLabel.textColor = .systemGreen
            } else if progressValue >= 0.5 {
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
