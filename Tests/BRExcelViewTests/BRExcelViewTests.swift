//
//  BRExcelViewTests.swift
//  BRExcelViewTests
//
//  Created by git burning on 30.09.25.
//

import XCTest
@testable import BRExcelView

final class BRExcelViewTests: XCTestCase {
    
    var excelView: BRExcelView!
    
    override func setUp() {
        super.setUp()
        excelView = BRExcelView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    }
    
    override func tearDown() {
        excelView = nil
        super.tearDown()
    }
    
    func testSimpleDataConfiguration() {
        let header = ["Name", "Age", "City"]
        let data = [
            ["Alice", "25", "New York"],
            ["Bob", "30", "London"]
        ]
        
        excelView.setData(header: header, data: data)
        
        XCTAssertNotNil(excelView)
        XCTAssertGreaterThan(excelView.intrinsicContentSize.height, 0)
    }
    
    func testCellModelCreation() {
        let cellModel = BRExcelCellModel(
            text: "Test",
            widthType: .fixed(100),
            textAlignment: .left
        )
        
        XCTAssertEqual(cellModel.text, "Test")
        XCTAssertEqual(cellModel.textAlignment, .left)
        
        if case .fixed(let width) = cellModel.widthType {
            XCTAssertEqual(width, 100)
        } else {
            XCTFail("Width type should be fixed")
        }
    }
    
    func testRowModelCreation() {
        let cells = [
            BRExcelCellModel(text: "Cell 1"),
            BRExcelCellModel(text: "Cell 2")
        ]
        
        let rowModel = BRExcelRowModel(cells: cells, height: 50, isHeader: true)
        
        XCTAssertEqual(rowModel.cells.count, 2)
        XCTAssertEqual(rowModel.height, 50)
        XCTAssertTrue(rowModel.isHeader)
    }
    
    func testColumnWidthTypes() {
        let fixedWidth: BRExcelCellWidthType = .fixed(100)
        let autoWidth: BRExcelCellWidthType = .auto
        let flexibleWidth: BRExcelCellWidthType = .flexible
        
        XCTAssertNotNil(fixedWidth)
        XCTAssertNotNil(autoWidth)
        XCTAssertNotNil(flexibleWidth)
    }
}
