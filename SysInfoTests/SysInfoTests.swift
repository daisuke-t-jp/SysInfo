//
//  SysInfoTests.swift
//  SysInfoTests
//
//  Created by Daisuke T on 2019/03/18.
//  Copyright © 2019 SysInfo. All rights reserved.
//

import XCTest

#if !SYSINFO_PROTOTYPE
@testable import SysInfo
#endif

class SysInfoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	// MARK: - Mach Host
    func testMachHostVMStatics() {
		let val = Mach.Host.vmStatics()
		
		XCTAssertFalse(val.freeSize == 0 &&
			val.activeSize == 0 &&
			val.inactiveSize == 0 &&
			val.wireSize == 0)
    }

	func testMachHostCPULoadInfo() {
		let val = Mach.Host.cpuLoadInfo()
		
		XCTAssertFalse(val.userTick == 0 &&
			val.systemTick == 0 &&
			val.idleTick == 0 &&
			val.niceTick == 0)
	}
	
	func testMachHostProcessorInfo() {
		let array = Mach.Host.processorInfo()
		
		XCTAssertNotEqual(array.count, 0)
		
		for elm in array {
			XCTAssertFalse(elm.userTick == 0 &&
				elm.systemTick == 0 &&
				elm.idleTick == 0 &&
				elm.niceTick == 0)
		}
	}
	
	
	// MARK: - Mach Task
	func testMachTaskBasicInfo() {
		let val = Mach.Task.basicInfo()
		
		XCTAssertFalse(val.virtualSize == 0 &&
			val.residentSize == 0 &&
			val.residentSizeMax == 0)
	}
	
	func testMachTaskThreadBasicInfo() {
		let array = Mach.Task.threadBasicInfo()
		
		XCTAssertNotEqual(array.count, 0)
	}
	
	
	// MARK: - Report OS
	func testReportOSMemory() {
		let val = Report.OS.memory()
		
		XCTAssertFalse(val.totalSize == 0 &&
			val.usedSize == 0 &&
			val.unusedSize == 0 &&
			val.freeSize == 0 &&
			val.activeSize == 0 &&
			val.inactiveSize == 0 &&
			val.wireSize == 0)
	}
	
	func testReportOSCPU() {
		let val = Report.OS.cpu()
		
		XCTAssertFalse(val.userUsage == 0 &&
			val.systemUsage == 0 &&
			val.idleUsage == 0)
	}
	
	func testReportOSProcessors() {
		let array = Report.OS.processors()
		
		XCTAssertNotEqual(array.count, 0)
	}
	
	
	// MARK: - Report Process
	func testReportProcessMemory() {
		let val = Report.Process.memory()
		
		XCTAssertNotEqual(val.residentSize, 0)
	}
	
	func testReportProcessCPU() {
		// NOP
	}
	
	func testReportProcessThread() {
		let val = Report.Process.thread()
		
		XCTAssert(val.totalNum > 0)
		XCTAssertEqual(val.totalNum, val.busyNum + val.idleNum)
	}
	
}
