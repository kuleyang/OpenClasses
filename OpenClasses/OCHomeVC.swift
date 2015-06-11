//
//  OCHomeVC.swift
//  OpenClasses
//
//  Created by mike on 15/6/5.
//  Copyright (c) 2015年 mike. All rights reserved.
//

import UIKit

class OCHomeVC: UITableViewController,UITableViewDelegate {


    var homeArray:NSMutableArray?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        configModel()
        handleNofiticaionts()
    }
    
//    处理模型
    func configModel(){
        
        WTRequestCenter.sharedQueue.addOperationWithBlock { () -> Void in
            self.homeArray = NSMutableArray()
            self.request()
        }
        
    }
//    处理视图
    func configView(){
        self.tableView.registerNib(UINib(nibName: "OCHomeTitleCell", bundle: nil), forCellReuseIdentifier: "OCHomeTitleCell");
        
    }
    
    
//    请求数据
    func request(){
        WTRequestCenter.doURLRequest(Method.GET, urlString: "", parameters: nil, encoding: ParameterEncoding.URL, finished: { (response, data) -> Void in
//            todo:处理数据
//            asdjsadklasjkda
            
//            使用数据
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.reloadUI()
            })
        }) { (error) -> Void in
            
        }
    }
    
//    刷新UI
    func reloadUI(){
    
    }
    
//    处理notification
    func handleNofiticaionts(){
        
//
        NSNotificationCenter.defaultCenter().addObserverForName("notificationName", object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
            
            self.reloadUI()
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OCHomeTitleCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    //    MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var height:CGFloat!
        height = 100
        
        
        return height
    
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }


}
