//
//  ExtensionsSpec.swift
//  Primedian-iOSTests
//
//  Created by Christopher Szatmary on 2019-08-04.
//

import Quick
import Nimble
@testable import Primedian_iOS

class ExtensionsSpec: QuickSpec {
    override func spec() {
        describe("Extensions tests") {
            describe("UIColor(hex:) tests") {
                it("creates a new UIColor instance from the hex number") {
                    let color = UIColor(hex: 0xABABAB)
                    let expected = UIColor(red: 171 / 255, green: 171 / 255, blue: 171 / 255, alpha: 1)
                    
                    expect(color).to(equal(expected))
                }
            }
        }
    }
}
