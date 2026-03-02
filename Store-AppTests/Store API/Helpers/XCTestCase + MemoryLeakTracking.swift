//
//  XCTestCase + MemoryLeakTracking.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 19.02.2026.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
}
