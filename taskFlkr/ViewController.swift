//
//  ViewController.swift
//  taskFlkr
//
//  Created by Test on 1/16/18.
//  Copyright © 2018 opensource. All rights reserved.
//

import UIKit



enum UIUserInterfaceIdiom: Int{
    case phone
    case pad
}

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var imagesArray = [String]()
    
    var image:UIImage?
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.reloadData()
        getJsonData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    func getJsonData(){
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath:path), options: .mappedIfSafe)
                
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                //print(jsonResult)
                if let jsonItems = jsonResult["items"] {
                    for item in jsonItems as! [[String:AnyObject]]{
                        let imageurlString = item["media"]!["m"] as? String
                        imagesArray.append(imageurlString!)
                        
                    }
                }
                
                
            } catch  {
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! imageCollectionViewCell
        
        cell.cellImage.downLoadImage(from: imagesArray[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width
        
        switch UIDevice.current.userInterfaceIdiom  {
        case .phone :
            
            return CGSize(width: width/3, height: 150)
        case .pad:
            return CGSize(width: width/4, height: 150)
        default:
            
            return CGSize(width: width/3, height: 150)
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    
}

// get images from urls
extension UIImageView{
    
    func  downLoadImage(from url:String){
        let urlRequets = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequets) { (data, response, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            DispatchQueue.global().async {
                let newImage = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.image = newImage
                }
            }
            
        }
        task.resume()
    }
    
    
}

