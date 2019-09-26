//
//  PostsListVC.swift
//  grio-test
//
//  Created by Glauco Valdes on 9/26/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import UIKit

class PostsListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var postItems : [Post] = [Post]()
    var indexPost : Int = 0
    var filter : String = "Date"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        
        self.loadData()
        
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(openAdd))
        self.navigationItem.rightBarButtonItem  = addButton
        
        self.title = "List of posts"

    }
    
    @objc func openAdd(){
        let storyboard: UIStoryboard = UIStoryboard(name: "AddPost", bundle: nil)
        let addPostVC: AddPostVC = storyboard.instantiateViewController(withIdentifier: "AddPostVC") as! AddPostVC
        
        self.navigationController?.pushViewController(addPostVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func loadData(){
        DispatchQueue.main.async {
            ApiManager.sharedInstance.getPost(index: self.indexPost,filter: self.filter, completion: {result in
                if(result.posts.count > 0){
                    self.postItems.append(contentsOf: result.posts)
                    self.tableView.reloadData()
                    self.indexPost += 1
                }
            })
        }
    }
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        self.filter = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        self.indexPost = 0
        self.postItems = [Post]()
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        self.loadData()
    }
}

extension PostsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostsListTVC.reuseIdentifier, for: indexPath) as! PostsListTVC
        
        
        
        cell.setCell(post: self.postItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.postItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.postItems.count {
            self.loadData()
        }
    }
    
}
