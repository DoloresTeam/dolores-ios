//
//  DoloresUITests.swift
//  DoloresUITests
//
//  Created by GongXiang on 6/27/17.
//  Copyright © 2017 Dolores. All rights reserved.
//

//fastlane snapshot

import XCTest

class DoloresUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)

        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {

        
        let app = XCUIApplication()
        app.tabBars.buttons["联系人"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["企业通讯录"].tap()
        tablesQuery.staticTexts["Java开发组"].tap()
        tablesQuery.staticTexts["严力"].tap()
        tablesQuery.buttons["聊天"].tap()
        
        let textView = app.textViews["text_view"]
        textView.tap()
        app.buttons["下一个键盘"].tap()
        
        let gHIKey = app.keys["G H I "]
        gHIKey.tap()
        textView.typeText("➍➌➍")
        app.buttons["给"].tap()
        app.keys["W X Y Z "].tap()
        textView.typeText("➒➍")
        gHIKey.tap()
        app.keys["D E F "].tap()
        textView.typeText("➏➍➌➑")
        
        let deleteKey = app.keys["delete"]
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()

    }
    
}
