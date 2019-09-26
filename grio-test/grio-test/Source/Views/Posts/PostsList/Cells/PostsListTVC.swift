//
//  PostsListTVC.swift
//  grio-test
//
//  Created by Glauco Valdes on 9/26/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import UIKit

class PostsListTVC: UITableViewCell {
    
    public static let reuseIdentifier = "PostsListTVC"
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var social: UILabel!
    
    @IBOutlet weak var postText: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(post : Post){
        self.username.text = post.author.username
        
        self.time.text = post.message.date.getElapsedInterval()
        self.social.text = "Views: " + String(post.message.views) + " Likes: " + String(post.message.likes)
        self.postText.text = post.message.body.text
        
        self.avatarImage.image = nil
        self.avatarImage.downloadFromInternet(from: post.author.avatar)
        
        self.postImage.image = nil
        self.postImage.downloadFromInternet(from: post.message.body.image)
        
        if(task != nil){
            task!.suspend()
        }
        
        self.postImage.image = nil
        self.postImage.layoutIfNeeded()
        self.postImage.layoutSubviews()
        
        self.getImage(downloadURL: post.message.body.image,messageId: post.message.id)
    }
    let session = URLSession(configuration: .default)
    var task : URLSessionDataTask?
    func getImage(downloadURL : String,messageId : String){
        self.showImageLoading()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(messageId + ".jpg")
        if FileManager.default.fileExists(atPath: filePath.path) {
            self.hideImageLoading()
            self.postImage.image = UIImage(contentsOfFile: filePath.path)
        }else{
            task = session.dataTask(with: URL(string: downloadURL)!, completionHandler: { (data, response, error) in
                if error != nil {
                    self.hideImageLoading()
                } else {
                    if (response as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self.postImage.image = image
                                do {
                                    try data!.write(to:filePath)
                                    
                                } catch {
                                    print(error.localizedDescription)
                                }
                                self.hideImageLoading()
                            }
                        } else {
                            self.hideImageLoading()
                        }
                        
                    } else {
                        self.hideImageLoading()
                    }
                }
            })
            
            task!.resume()
        }
    }
    
    var imageLoading : UIActivityIndicatorView  = UIActivityIndicatorView()
    func showImageLoading(){
        self.imageLoading.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        self.imageLoading.center = self.postImage.center
        self.imageLoading.hidesWhenStopped = true
        self.imageLoading.style = .gray
        self.postImage.addSubview(imageLoading)
        self.imageLoading.startAnimating()
    }
    func hideImageLoading(){
        self.imageLoading.stopAnimating()
    }
}
