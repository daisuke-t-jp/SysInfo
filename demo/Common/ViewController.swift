//
//  ViewController.swift
//  Baconian
//
//  Created by Daisuke T on 2019/03/27.
//  Copyright © 2019 Baconian. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

import Baconian

class ViewController: CrossPlatformViewController, ReporterCompactViewDelegate {
    
    // MARK: Enum, Const
    enum Control: Int {
        case start = 0
        case stop = 1
    }
    
    enum Frequency: Int {
        case normally = 0
        case often = 1
        case veryOften = 2
    }
    
    
    // MARK: IBOutlet
    @IBOutlet weak var viewReporter: ReporterCompactView!
    var viewReporterProgrammatically: ReporterCompactView!
    
    @IBOutlet weak var labelViewStoryboard: CrossPlatformLabel!
    @IBOutlet weak var labelViewPragrammatically: CrossPlatformLabel!
    
    @IBOutlet weak var segmentedControlReporterControl: CrossPlatformSegmentedControl!
    @IBOutlet weak var segmentedControlReporterFrequency: CrossPlatformSegmentedControl!
    
    @IBOutlet weak var labelStressMemorySize: CrossPlatformLabel!
    @IBOutlet weak var buttonStressMemoryAlloc: CrossPlatformButton!
    @IBOutlet weak var buttonStressMemoryDealloc: CrossPlatformButton!
    
    @IBOutlet weak var labelStressOperationCount: CrossPlatformLabel!
    @IBOutlet weak var buttonStressOperationAdd: CrossPlatformButton!
    @IBOutlet weak var buttonStressOperationCancel: CrossPlatformButton!
    
    
    // MARK: Property
    let stress = StressUtility()
}


// MARK: Life cycle
extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewReporter.delegate = self
        viewReporterProgrammatically = ReporterCompactView(frame: CrossPlatformRect(x: 0,
                                                                                    y: 0,
                                                                                    width: ReporterCompactView.xibWidth,
                                                                                    height: ReporterCompactView.xibHeight))
        viewReporterProgrammatically.backgroundColor = .darkGray
        self.view.addSubview(viewReporterProgrammatically)
        
        
        segmentedControlReporterControl.selectedSegmentIndex = Control.stop.rawValue
        segmentedControlReporterControl.addTarget(self, action: #selector(segmentedControlReporterControlEvent(_:)))
        
        segmentedControlReporterFrequency.selectedSegmentIndex = Frequency.normally.rawValue
        segmentedControlReporterFrequency.addTarget(self, action: #selector(segmentedControlReporterFrequencyEvent(_:)))
        
        buttonStressMemoryAlloc.addTarget(self, action: #selector(buttonStressMemoryAllocEvent(_:)))
        buttonStressMemoryDealloc.addTarget(self, action: #selector(buttonStressMemoryDeallocEvent(_:)))
        buttonStressOperationAdd.addTarget(self, action: #selector(buttonStressOperationAddEvent(_:)))
        buttonStressOperationCancel.addTarget(self, action: #selector(buttonStressOperationCancelEvent(_:)))
        
        updateStressMemorySizeUpdate()
        updateStressOperationCountUpdate()
    }
    
    #if os(iOS)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewReporterProgrammatically.frame.origin.x = viewReporter.frame.origin.x
        viewReporterProgrammatically.frame.origin.y = labelViewPragrammatically.frame.origin.y + labelViewPragrammatically.frame.height + 10
    }
    #elseif os(macOS)
    override func viewDidLayout() {
        super.viewDidLayout()
        
        viewReporterProgrammatically.frame.origin.x = viewReporter.frame.origin.x
        viewReporterProgrammatically.frame.origin.y = labelViewPragrammatically.frame.origin.y - 10 - viewReporterProgrammatically.frame.height
    }
    #endif
}


// MARK: ReporterCompactViewDelegate
extension ViewController {
    
    func reporter(_ manager: Reporter, didUpdate data: Reporter.Data) {
        print("# Report")
        
        print("## OS")
        print("### Memory")
        print("- physicalSize: \(data.osMemory.physicalSize.memoryByteFormatString)")
        print("- freeSize: \(data.osMemory.freeSize.memoryByteFormatString)")
        print("- inactiveSize: \(data.osMemory.inactiveSize.memoryByteFormatString)")
        print("- wireSize: \(data.osMemory.wireSize.memoryByteFormatString)")
        print("- usedSize: \(data.osMemory.usedSize.memoryByteFormatString)")
        print("- unusedSize: \(data.osMemory.unusedSize.memoryByteFormatString)")
        print("")
        
        print("### CPU")
        print(String.init(format: "- userUsage: %.2f", data.osCPU.userUsage))
        print(String.init(format: "- systemUsage: %.2f", data.osCPU.systemUsage))
        print(String.init(format: "- idleUsage: %.2f", data.osCPU.idleUsage))
        print(String.init(format: "- niceUsage: %.2f", data.osCPU.niceUsage))
        print(String.init(format: "- usage: %.2f", data.osCPU.usage))
        print("")
        
        print("### Processors")
        for i in 0..<data.osProcessors.count {
            print("- Core No.\(i)")
            print(String.init(format: "    - userUsage: %.2f", data.osCPU.userUsage))
            print(String.init(format: "    - systemUsage: %.2f", data.osCPU.systemUsage))
            print(String.init(format: "    - idleUsage: %.2f", data.osCPU.idleUsage))
            print(String.init(format: "    - niceUsage: %.2f", data.osCPU.niceUsage))
            print(String.init(format: "    - usage: %.2f", data.osCPU.usage))
            print("")
        }
        
        
        print("## Process")
        print("### Memory")
        print("- residentSize: \(data.processMemory.residentSize.memoryByteFormatString)")
        print("")
        
        print("### CPU")
        print(String.init(format: "- usage: %.2f", data.processCPU.usage))
        print(String.init(format: "- time: %.2f", data.processCPU.time))
        print("")
        
        print("### Thread")
        print("- totalNum: \(data.processThread.totalNum)")
        print("- busyNum: \(data.processThread.busyNum)")
        print("- idleNum: \(data.processThread.idleNum)")
        print("")
    }
    
}


// MARK: Control
extension ViewController {
    
    @IBAction func segmentedControlReporterControlEvent(_ sender: AnyObject) {
        switch Control(rawValue: segmentedControlReporterControl.selectedSegmentIndex)! {
        case .start:
            viewReporter.start()
            viewReporterProgrammatically.start()
            
        case .stop:
            viewReporter.stop()
            viewReporterProgrammatically.stop()
        }
    }
    
}


// MARK: Frequency
extension ViewController {
    
    @IBAction func segmentedControlReporterFrequencyEvent(_ sender: AnyObject) {
        switch Frequency(rawValue: segmentedControlReporterFrequency.selectedSegmentIndex)! {
        case .normally:
            viewReporter.frequency = .normally
            viewReporterProgrammatically.frequency = .normally
            
        case .often:
            viewReporter.frequency = .often
            viewReporterProgrammatically.frequency = .often
            
        case .veryOften:
            viewReporter.frequency = .veryOften
            viewReporterProgrammatically.frequency = .veryOften
        }
    }
    
}


// MARK: Memory
extension ViewController {
    
    @IBAction func buttonStressMemoryAllocEvent(_ sender: AnyObject) {
        stress.memoryAlloc(1024 * 1024 * 32)
        updateStressMemorySizeUpdate()
    }
    
    @IBAction func buttonStressMemoryDeallocEvent(_ sender: AnyObject) {
        stress.memoryDealloc()
        updateStressMemorySizeUpdate()
    }
    
    func updateStressMemorySizeUpdate() {
        labelStressMemorySize.text = "Memory Size: \(stress.memorySize().memoryByteFormatString)"
    }
    
}


// MARK: Operation
extension ViewController {
    
    @IBAction func buttonStressOperationAddEvent(_ sender: AnyObject) {
        stress.operationAdd(1024 * 32, sleepInterval: 0.01)
        updateStressOperationCountUpdate()
    }
    
    @IBAction func buttonStressOperationCancelEvent(_ sender: AnyObject) {
        stress.operationCancel()
        updateStressOperationCountUpdate()
    }
    
    func updateStressOperationCountUpdate() {
        labelStressOperationCount.text = "Operation Count: \(stress.operationCount())"
    }
    
}

