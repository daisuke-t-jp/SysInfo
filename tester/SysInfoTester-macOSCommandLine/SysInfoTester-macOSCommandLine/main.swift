//
//  main.swift
//  SysInfo
//
//  Created by Daisuke T on 2019/03/19.
//  Copyright © 2019 SysInfo. All rights reserved.
//

import Foundation

let commandLine = CommandLine()

while true {
	
	autoreleasepool {
		let data = FileHandle.standardInput.availableData
		
		commandLine.run(data)
	}
	
}
