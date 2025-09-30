//
//  BRExcelRowView.swift
//  BRExcelView
//
//  Created by git burning on 30.09.25.
//

import UIKit

class BRExcelRowView: UIView {
    
    private var cellViews: [BRExcelCellView] = []
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var customRowView: BRExcelCustomRowView?
    private var heightConstraint: NSLayoutConstraint?
    
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
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    /// 使用 RowModel 配置行
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        // 设置行高
        heightConstraint?.isActive = false
        heightConstraint = heightAnchor.constraint(equalToConstant: model.height)
        heightConstraint?.isActive = true
        
        // 检查是否有自定义行视图
        if let customRowViewType = model.customRowViewType {
            configureCustomRow(with: model, columnWidths: columnWidths, viewType: customRowViewType)
        } else {
            configureDefaultRow(with: model, columnWidths: columnWidths)
        }
    }
    
    /// 配置默认行（使用单元格）
    private func configureDefaultRow(with model: BRExcelRowModel, columnWidths: [CGFloat]) {
        // 隐藏自定义视图（如果有）
        customRowView?.isHidden = true
        stackView.isHidden = false
        
        // 清除旧的cell
        cellViews.forEach { $0.removeFromSuperview() }
        cellViews.removeAll()
        
        // 添加单元格
        for (index, cellModel) in model.cells.enumerated() {
            let cellView = BRExcelCellView()
            cellView.translatesAutoresizingMaskIntoConstraints = false
            
            let width = index < columnWidths.count ? columnWidths[index] : nil
            cellView.configure(with: cellModel, width: width)
            
            if model.isHeader {
                cellView.layer.borderWidth = 1
            }
            
            stackView.addArrangedSubview(cellView)
            cellViews.append(cellView)
        }
    }
    
    /// 配置自定义行
    private func configureCustomRow(with model: BRExcelRowModel, columnWidths: [CGFloat], viewType: BRExcelCustomRowView.Type) {
        // 隐藏默认的 stackView
        stackView.isHidden = true
        
        // 移除旧的自定义视图
        customRowView?.removeFromSuperview()
        
        // 创建新的自定义视图
        let newCustomView = viewType.init(frame: .zero)
        newCustomView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newCustomView)
        
        NSLayoutConstraint.activate([
            newCustomView.topAnchor.constraint(equalTo: topAnchor),
            newCustomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            newCustomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newCustomView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        customRowView = newCustomView
        
        // 配置自定义视图
        if let configuration = model.customRowViewConfiguration {
            configuration(newCustomView, model, columnWidths)
        } else {
            newCustomView.configure(with: model, columnWidths: columnWidths)
        }
    }
}
