//
//  Notes_appUITests.swift
//  Notes appUITests
//
//  Created by Andrii Kryvytskyi on 10.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import XCTest

class Notes_app_MasterView_UI_tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testMasterViewControllerAddNote() {

    }
    
    func testMasterViewControllerAddNoteWithAttachment() {
        
    }

    func testLaunchPerformance() {
        if #available(iOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
