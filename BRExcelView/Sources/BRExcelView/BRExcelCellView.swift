//
//  BRExcelCellView.swift
//  BRExcelView
//
//  Created by git burning on 30.09.25.
//

import UIKit

class BRExcelCellView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var customContentView: UIView?
    private var widthConstraint: NSLayoutConstraint?
    private var labelConstraints: [NSLayoutConstraint] = []
    private var customViewConstraints: [NSLayoutConstraint] = []
    
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
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        
        addSubview(label)
        
        // 默认内边距
        updateLabelConstraints(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    private func updateLabelConstraints(insets: UIEdgeInsets) {
        // 移除旧的约束
        NSLayoutConstraint.deactivate(labelConstraints)
        labelConstraints.removeAll()
        
        // 添加新的约束（带内边距）
        labelConstraints = [
            label.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    /// 使用 CellModel 配置单元格
    func configure(with model: BRExcelCellModel, width: CGFloat? = nil) {
        backgroundColor = model.backgroundColor
        
        // 配置边框
        layer.borderColor = model.borderColor.cgColor
        layer.borderWidth = model.borderWidth
        layer.cornerRadius = model.cornerRadius
        if model.cornerRadius > 0 {
            clipsToBounds = true
        }
        
        // 如果有自定义视图，使用自定义视图
        if let customView = model.customView {
            setupCustomView(customView, insets: model.contentInsets)
        } else {
            // 否则使用 label
            label.isHidden = false
            customContentView?.isHidden = true
            
            // 优先使用富文本
            if let attributedText = model.attributedText {
                label.attributedText = attributedText
                label.textAlignment = model.textAlignment
            } else {
                label.text = model.text
                label.textAlignment = model.textAlignment
                label.font = model.font
                label.textColor = model.textColor
            }
            
            // 更新内边距
            updateLabelConstraints(insets: model.contentInsets)
        }
        
        // 设置宽度约束
        widthConstraint?.isActive = false
        
        if let width = width {
            widthConstraint = widthAnchor.constraint(equalToConstant: width)
            widthConstraint?.isActive = true
        } else if let modelWidth = model.getWidth() {
            widthConstraint = widthAnchor.constraint(equalToConstant: modelWidth)
            widthConstraint?.isActive = true
        }
    }
    
    private func setupCustomView(_ customView: UIView, insets: UIEdgeInsets) {
        // 移除旧的自定义视图
        customContentView?.removeFromSuperview()
        
        label.isHidden = true
        customContentView = customView
        customView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(customView)
        
        // 移除旧的约束
        NSLayoutConstraint.deactivate(customViewConstraints)
        customViewConstraints.removeAll()
        
        // 添加新的约束
        customViewConstraints = [
            customView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            customView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
        ]
        
        NSLayoutConstraint.activate(customViewConstraints)
    }
}
