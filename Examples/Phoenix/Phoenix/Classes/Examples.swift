//
//  Examples.swift
//  Phoenix
//
//  Created by Anthony Persaud on 6/2/19.
//  Copyright © 2019 Modernistik. All rights reserved.
//

import Foundation
import Modernistik

class SleepWorker : Worker {
    var seconds: TimeInterval = 5
    
    static func enqueue(sleep: TimeInterval) {
        let op = SleepWorker()
        op.seconds = sleep
        op.enqueue()
    }
    
    override func work() {
        
        Thread.sleep(forTimeInterval: seconds)
        completed()
    }
}


public class NetworkedWorker : Worker {
    
    override public func configure() {
        let networkCheck = NetworkCheckOperation()
        networkCheck.queuePriority = .veryHigh
        addDependency(networkCheck)
        queue.addOperation(networkCheck)
    }
    
}


/* Assume we always need a network connection as a dependency to doing our task.
This worker will inherit from NetworkedWorker, which all
 it does is add a NetworkCheckOperation() as a dependency task.
 Only when that NetworkCheckOperation completes, will this
 task be run
 */
public class BasicWorker : NetworkedWorker {
    var loopCount: Int { return params["loop"] as? Int ?? 0 }
    
    public override func work() {
        // showing how you can do some asynchronous tasks. Just call
        // completed() or failed() when done.
        dispatch {
            
            (0...self.loopCount).forEach({ (index) in
                self.log("Working.... (i: \(index))")
                Thread.sleep(forTimeInterval: 1)
            })
        }
    }
}
