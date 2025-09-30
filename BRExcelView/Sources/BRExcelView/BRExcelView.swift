//
//  BRExcelView.swift
//  BRExcelView
//
//  Created by git burning on 30.09.25.
//

import UIKit

public class BRExcelView: UIView {
    
    // MARK: - Properties
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var rowViews: [BRExcelRowView] = []
    private var columnWidths: [CGFloat] = []
    private var rowModels: [BRExcelRowModel] = []
    private var contentHeightConstraint: NSLayoutConstraint?
    private var contentWidthConstraint: NSLayoutConstraint?
    private var lastLayoutWidth: CGFloat = 0
    
    // MARK: - 公共配置属性
    
    /// 自动适应宽度模式
    /// - true: 当内容宽度小于视图宽度时，扩展列宽以填充整个视图
    /// - false: 宽度等于内容宽度，不自动扩展
    public var enableAutoFit: Bool = false
    
    /// 最大高度限制（超过则纵向滚动）
    public var maxHeight: CGFloat?
    
    /// 最大宽度限制（超过则横向滚动）
    public var maxWidth: CGFloat?
    
    /// 分隔线配置
    public struct SeparatorStyle {
        public var color: UIColor
        public var width: CGFloat
        public var showHorizontal: Bool
        public var showVertical: Bool
        
        public init(
            color: UIColor = .lightGray,
            width: CGFloat = 0.5,
            showHorizontal: Bool = true,
            showVertical: Bool = true
        ) {
            self.color = color
            self.width = width
            self.showHorizontal = showHorizontal
            self.showVertical = showVertical
        }
        
        public static let none = SeparatorStyle(showHorizontal: false, showVertical: false)
        public static let `default` = SeparatorStyle()
    }
    
    /// 分隔线样式
    public var separatorStyle: SeparatorStyle = .default
    
    /// 表格整体圆角
    public var tableCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = tableCornerRadius
            clipsToBounds = tableCornerRadius > 0
        }
    }
    
    /// 表格整体边框
    public var tableBorderColor: UIColor? {
        didSet {
            layer.borderColor = tableBorderColor?.cgColor
        }
    }
    
    public var tableBorderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = tableBorderWidth
        }
    }
    
    /// 滚动指示器颜色
    public var scrollIndicatorColor: UIColor? {
        didSet {
            if let color = scrollIndicatorColor {
                scrollView.indicatorStyle = color == .white ? .white : (color == .black ? .black : .default)
            }
        }
    }
    
    /// 是否显示滚动指示器
    public var showsScrollIndicators: Bool = false {
        didSet {
            scrollView.showsHorizontalScrollIndicator = showsScrollIndicators
            scrollView.showsVerticalScrollIndicator = showsScrollIndicators
        }
    }
    
    /// 是否启用弹性滚动
    public var bounces: Bool = false {
        didSet {
            scrollView.bounces = bounces
        }
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    public func setData(rows: [BRExcelRowModel]) {
        self.rowModels = rows
        calculateColumnWidths()
        reloadData()
    }
    
    public func setData(
        header: [String]?,
        data: [[String]],
        headerHeight: CGFloat = 50,
        rowHeight: CGFloat = 44,
        columnWidthTypes: [BRExcelCellWidthType]? = nil
    ) {
        var rows: [BRExcelRowModel] = []
        
        if let header = header {
            let headerCells = header.enumerated().map { index, text -> BRExcelCellModel in
                let widthType = columnWidthTypes?[safe: index] ?? .auto
                return BRExcelCellModel(
                    text: text,
                    widthType: widthType,
                    backgroundColor: .systemGray5
                )
            }
            rows.append(BRExcelRowModel(cells: headerCells, height: headerHeight, isHeader: true))
        }
        
        for rowData in data {
            let cells = rowData.enumerated().map { index, text -> BRExcelCellModel in
                let widthType = columnWidthTypes?[safe: index] ?? .auto
                return BRExcelCellModel(text: text, widthType: widthType)
            }
            rows.append(BRExcelRowModel(cells: cells, height: rowHeight))
        }
        
        setData(rows: rows)
    }
    
    public func reloadData() {
        rowViews.forEach { $0.removeFromSuperview() }
        rowViews.removeAll()
        
        for rowModel in rowModels {
            let rowView = BRExcelRowView()
            rowView.configure(with: rowModel, columnWidths: columnWidths)
            contentStackView.addArrangedSubview(rowView)
            rowViews.append(rowView)
        }
        
        adjustContentSize()
        lastLayoutWidth = bounds.width
    }
    
    private func updateColumnWidths() {
        calculateColumnWidths()
        
        for (index, rowView) in rowViews.enumerated() {
            guard index < rowModels.count else { break }
            rowView.configure(with: rowModels[index], columnWidths: columnWidths)
        }
        
        adjustContentSize()
        lastLayoutWidth = bounds.width
    }
    
    // MARK: - Private Methods
    
    private func calculateColumnWidths() {
        guard !rowModels.isEmpty else { return }
        
        let maxColumns = rowModels.map { $0.cells.count }.max() ?? 0
        guard maxColumns > 0 else { return }
        
        columnWidths = Array(repeating: 0, count: maxColumns)
        var flexibleColumns: [Int] = []
        
        for columnIndex in 0..<maxColumns {
            var maxWidth: CGFloat = 0
            var hasFlexible = false
            
            for rowModel in rowModels {
                guard columnIndex < rowModel.cells.count else { continue }
                let cell = rowModel.cells[columnIndex]
                
                switch cell.widthType {
                case .fixed(let width):
                    maxWidth = max(maxWidth, width)
                case .auto:
                    maxWidth = max(maxWidth, cell.calculateAutoWidth())
                case .flexible:
                    hasFlexible = true
                }
            }
            
            if hasFlexible {
                flexibleColumns.append(columnIndex)
            } else {
                columnWidths[columnIndex] = maxWidth
            }
        }
        
        let availableViewWidth = bounds.width > 0 ? bounds.width : (superview?.bounds.width ?? UIScreen.main.bounds.width)
        
        if !flexibleColumns.isEmpty {
            let usedWidth = columnWidths.reduce(0, +)
            let availableWidth = max(availableViewWidth - usedWidth, 0)
            let flexibleWidth = availableWidth / CGFloat(flexibleColumns.count)
            
            for columnIndex in flexibleColumns {
                var minWidth: CGFloat = 80
                for rowModel in rowModels {
                    if columnIndex < rowModel.cells.count {
                        minWidth = max(minWidth, rowModel.cells[columnIndex].minWidth)
                    }
                }
                columnWidths[columnIndex] = max(flexibleWidth, minWidth)
            }
        }
        
        if enableAutoFit && availableViewWidth > 0 {
            let totalWidth = columnWidths.reduce(0, +)
            if totalWidth < availableViewWidth {
                let extraSpace = availableViewWidth - totalWidth
                let extraPerColumn = extraSpace / CGFloat(maxColumns)
                
                for i in 0..<maxColumns {
                    columnWidths[i] += extraPerColumn
                }
            }
        }
    }
    
    private func adjustContentSize() {
        let totalWidth = columnWidths.reduce(0, +)
        let totalHeight = rowModels.reduce(0) { $0 + $1.height }
        
        scrollView.contentSize = CGSize(width: totalWidth, height: totalHeight)
        
        for constraint in contentStackView.constraints where constraint.firstAttribute == .width || constraint.firstAttribute == .height {
            constraint.isActive = false
        }
        
        contentStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: totalWidth).isActive = true
        contentStackView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        
        updateContentSize(width: totalWidth, height: totalHeight)
    }
    
    private func updateContentSize(width: CGFloat, height: CGFloat) {
        updateContentWidth(width)
        updateContentHeight(height)
    }
    
    private func updateContentWidth(_ contentWidth: CGFloat) {
        contentWidthConstraint?.isActive = false
        
        let actualWidth: CGFloat
        let needsHorizontalScroll: Bool
        
        if let maxWidth = maxWidth {
            actualWidth = min(contentWidth, maxWidth)
            needsHorizontalScroll = contentWidth > maxWidth
        } else {
            actualWidth = contentWidth
            needsHorizontalScroll = false
        }
        
        scrollView.alwaysBounceHorizontal = needsHorizontalScroll
        scrollView.showsHorizontalScrollIndicator = needsHorizontalScroll
        
        contentWidthConstraint = widthAnchor.constraint(equalToConstant: actualWidth)
        contentWidthConstraint?.priority = .defaultHigh
        contentWidthConstraint?.isActive = true
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateContentHeight(_ contentHeight: CGFloat) {
        contentHeightConstraint?.isActive = false
        
        let actualHeight: CGFloat
        let needsVerticalScroll: Bool
        
        if let maxHeight = maxHeight {
            actualHeight = min(contentHeight, maxHeight)
            needsVerticalScroll = contentHeight > maxHeight
        } else {
            actualHeight = contentHeight
            needsVerticalScroll = false
        }
        
        scrollView.alwaysBounceVertical = needsVerticalScroll
        scrollView.showsVerticalScrollIndicator = needsVerticalScroll
        
        contentHeightConstraint = heightAnchor.constraint(equalToConstant: actualHeight)
        contentHeightConstraint?.priority = .defaultHigh
        contentHeightConstraint?.isActive = true
        
        invalidateIntrinsicContentSize()
    }
    
    public override var intrinsicContentSize: CGSize {
        let totalWidth = columnWidths.reduce(0, +)
        let totalHeight = rowModels.reduce(0) { $0 + $1.height }
        
        let actualWidth: CGFloat
        if let maxWidth = maxWidth {
            actualWidth = min(totalWidth, maxWidth)
        } else {
            actualWidth = totalWidth
        }
        
        let actualHeight: CGFloat
        if let maxHeight = maxHeight {
            actualHeight = min(totalHeight, maxHeight)
        } else {
            actualHeight = totalHeight
        }
        
        return CGSize(width: actualWidth, height: actualHeight)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !rowModels.isEmpty && bounds.width > 0 else { return }
        
        let widthChanged = abs(bounds.width - lastLayoutWidth) > 0.5
        guard widthChanged else { return }
        
        let needsRecalculation = rowModels.contains { rowModel in
            rowModel.cells.contains { cell in
                if case .flexible = cell.widthType {
                    return true
                }
                return false
            }
        }
        
        if needsRecalculation || enableAutoFit {
            updateColumnWidths()
        }
    }
}

// MARK: - Array Extension

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
