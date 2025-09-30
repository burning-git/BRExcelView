//
//  BRExcelCellModel.swift
//  BRExcelView
//
//  Created by git burning on 30.09.25.
//

import UIKit

/// 单元格宽度类型
public enum BRExcelCellWidthType {
    case fixed(CGFloat)      // 固定宽度
    case auto                // 自适应内容宽度
    case flexible            // 弹性宽度（会根据剩余空间自动分配）
}

/// 单元格数据模型
public class BRExcelCellModel {
    public var text: String
    public var widthType: BRExcelCellWidthType
    public var minWidth: CGFloat
    public var textAlignment: NSTextAlignment
    public var font: UIFont
    public var textColor: UIColor
    public var backgroundColor: UIColor
    public var contentInsets: UIEdgeInsets
    
    // 边框自定义
    public var borderColor: UIColor
    public var borderWidth: CGFloat
    public var cornerRadius: CGFloat
    
    // 高级自定义
    public var attributedText: NSAttributedString?
    public var customView: UIView?  // 完全自定义内容

    public init(
        text: String,
        widthType: BRExcelCellWidthType = .auto,
        minWidth: CGFloat = 80,
        textAlignment: NSTextAlignment = .center,
        font: UIFont = .systemFont(ofSize: 14),
        textColor: UIColor = .darkText,
        backgroundColor: UIColor = .white,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
        borderColor: UIColor = .lightGray,
        borderWidth: CGFloat = 0.5,
        cornerRadius: CGFloat = 0,
        attributedText: NSAttributedString? = nil,
        customView: UIView? = nil
    ) {
        self.text = text
        self.widthType = widthType
        self.minWidth = minWidth
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.contentInsets = contentInsets
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.attributedText = attributedText
        self.customView = customView
    }
    
    /// 计算自适应宽度
    func calculateAutoWidth() -> CGFloat {
        let textSize = (text as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 44),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).size
        
        // 宽度 = 文本宽度 + 左右内边距
        let totalWidth = textSize.width + contentInsets.left + contentInsets.right
        return max(totalWidth, minWidth)
    }
    
    /// 获取最终宽度
    func getWidth() -> CGFloat? {
        switch widthType {
        case .fixed(let width):
            return width
        case .auto:
            return calculateAutoWidth()
        case .flexible:
            return nil // 需要外部计算
        }
    }
}

/// 自定义行视图协议
public protocol BRExcelCustomRowView: UIView {
    /// 配置行视图
    /// - Parameters:
    ///   - model: 行数据模型
    ///   - columnWidths: 列宽数组
    func configure(with model: BRExcelRowModel, columnWidths: [CGFloat])
}

/// 行数据模型
public class BRExcelRowModel {
    public var cells: [BRExcelCellModel]
    public var height: CGFloat
    public var isHeader: Bool
    
    /// 自定义行视图类型（如果提供，将使用自定义视图而不是默认的单元格布局）
    public var customRowViewType: BRExcelCustomRowView.Type?
    
    /// 自定义行视图的配置闭包
    public var customRowViewConfiguration: ((BRExcelCustomRowView, BRExcelRowModel, [CGFloat]) -> Void)?
    
    public init(
        cells: [BRExcelCellModel],
        height: CGFloat = 44,
        isHeader: Bool = false,
        customRowViewType: BRExcelCustomRowView.Type? = nil,
        customRowViewConfiguration: ((BRExcelCustomRowView, BRExcelRowModel, [CGFloat]) -> Void)? = nil
    ) {
        self.cells = cells
        self.height = height
        self.isHeader = isHeader
        self.customRowViewType = customRowViewType
        self.customRowViewConfiguration = customRowViewConfiguration
    }
    
    /// 便捷初始化方法 - 从字符串数组创建
    public convenience init(
        texts: [String],
        widthType: BRExcelCellWidthType = .auto,
        minWidth: CGFloat = 80,
        height: CGFloat = 44,
        isHeader: Bool = false
    ) {
        let cells = texts.map { text in
            BRExcelCellModel(
                text: text,
                widthType: widthType,
                minWidth: minWidth,
                backgroundColor: isHeader ? .systemGray5 : .white
            )
        }
        self.init(cells: cells, height: height, isHeader: isHeader)
    }
}
