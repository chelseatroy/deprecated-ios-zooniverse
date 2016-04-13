import UIKit

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var objects = NSMutableArray()
    var indicator = UIActivityIndicatorView()
    
    var tableView: UITableView  =   UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame         =   CGRectMake(0, 20, 420, 700);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
        self.indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.indicator.center                     = self.view.center
        self.view.addSubview(indicator)
        
        data_request()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            //self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }
    
    
    //This method makes the http request
    func data_request() {
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.whiteColor()
        
        let url:NSURL = NSURL(string: "http://localhost:8080/projects")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        //this is how you would add query params or request body to your request
        //let paramString = "data=Hello"
        //request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                //stringified json in the response. You could print this to see it all as a string.
                //let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    if let items = json["projects"] as? NSArray {
                        
                        for item in items {
                            // construct your model objects here
                            print(item["description"])
                            let project = Project(json: item as! NSDictionary)
                            
                            //self.objects.addObject(project)
                            
                            self.insertNewObject(project)
                        }
                    }
                }
            }
            
        }
        
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        func insertNewObject(sender: AnyObject) {
            objects.insertObject(sender, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let object = objects[indexPath.row] as! Project
        cell.textLabel!.text = object.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
}

