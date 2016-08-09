//
//  DependencyInjectorNSOperation.swift
//  Dependency_Manager
//
//  Created by Developer on 10/08/16.
//  Copyright © 2016 Sandeep. All rights reserved.
//

import Foundation

class DependencyInjectorNSOperation : NSBlockOperation {
    var isSuccess : Bool = true
    var cleanUpCode : ((DependencyInjectorNSOperation) -> Void)? = nil
    
    override func cancel() {
        for operation in self.dependencies {
            operation.cancel()
            isSuccess = false
        }
        super.cancel()
    }
    
    override func start() {
        if cancelled == true {
            return
        }
        else if self.dependencies.count > 0 {
            for tasks in self.dependencies {
                if (tasks as! DependencyInjectorNSOperation).isSuccess != true{
                    cleanUpCode!(self)
                    return
                }
            }
             super.start()
        }
        else{
            super.start()
        }
    }
}