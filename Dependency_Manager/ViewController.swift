//
//  ViewController.swift
//  Dependency_Manager
//
//  Created by Developer on 10/08/16.
//  Copyright © 2016 Sandeep. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tasks : [DependencyInjectorNSOperation]? = nil
    var operationQueue : NSOperationQueue? = nil
    
    @IBAction func Track1ButtonTapped(sender: AnyObject) {
        let task = self.createBlockOperations(withMessage: "Task 1")
        self.addTasksToQueue(task)
        task.start()
        //am in testing
    }
    
    
    @IBAction func Track2ButtonTapped(sender: AnyObject) {
        let task = self.createBlockOperations(withMessage: "Task 2")
        self.addTasksToQueue(task)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        let topTask = tasks?.first
        guard let _ = topTask else {
            print("nothing in queue")
            return
        }
        topTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        operationQueue = NSOperationQueue.init()
        tasks = [DependencyInjectorNSOperation]()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBlockOperations(withMessage message : String) -> DependencyInjectorNSOperation {
//        NSURLSessionUploadTask
        let task = DependencyInjectorNSOperation()
        task.cleanUpCode = { (passedTask) in
            if self.tasks?.indexOf(task) != nil {
                self.tasks?.removeAtIndex((self.tasks?.indexOf(task))!)
            }
        }
        task.addExecutionBlock({
            for var i in 1 ... 5 {
                if task.cancelled == true {
                    self.tasks?.removeAtIndex((self.tasks?.indexOf(task))!)
                    return
                }
                sleep(5)
                print(message)
                i += 1
            }
            if self.tasks?.indexOf(task) != nil {
                self.tasks?.removeAtIndex((self.tasks?.indexOf(task))!)
            }
        })
        return task
    }
    
    @IBAction func task3ButtonTapped(sender: AnyObject) {
        let task = self.createBlockOperations(withMessage: "Task 3")
        operationQueue?.addOperation(task)
    }
    
    func addTasksToQueue(task : DependencyInjectorNSOperation) {
        if(tasks?.count == 0){
            tasks?.append(task)
        }
        else{
            let prevTask = tasks?.last
            guard let unwrappedPrevTask = prevTask else {
                tasks?.append(task)
                operationQueue?.addOperation(task)
                return
            }
            task.addDependency(unwrappedPrevTask)
            tasks?.append(task)
        }
        operationQueue?.addOperation(task)
    }
}

