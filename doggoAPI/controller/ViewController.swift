//
//  ViewController.swift
//  doggoAPI
//
//  Created by Jagdeep Singh on 22/02/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    var breeds: [String] = []
    let randomImageEndpoint = DogAPI.Endpoint.randomImageFromAllDogsColection.url
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerView.dataSource = self
        pickerView.delegate = self
        print(randomImageEndpoint)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        imageCalling()
        DogAPI.requestBreedsList(completionHandler: handleBreedsListResponse(breeds:error:))
        
        
    }

    @IBAction func refreshAction(_ sender: Any) {
        imageCalling()
    }
    func imageCalling() {
        DogAPI.requestRandomImage { (imageData, error) in
            
                guard let imageUrl = URL(string: imageData?.message ?? "") else {
                    return
                }
                
                DogAPI.requestImageFile(url: imageUrl) { (image, error) in
                    self.handleImageFileResponse(image: image, error: error)
                }
    
      }
    }
    func breedImageCalling(breed: String) {
            DogAPI.requestRandomBreedImage(breed: breed) { (imageData, error) in
               
                    guard let imageUrl = URL(string: imageData?.message ?? "") else {
                        return
                    }
                    
                    DogAPI.requestImageFile(url: imageUrl) { (image, error) in
                        self.handleImageFileResponse(image: image, error: error)
                    }
        
          }
    }
    func handleBreedsListResponse(breeds: [String],error: Error?) {
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
         }

    }
    
}

extension ViewController: UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        breedImageCalling(breed: breeds[row])
    }
    
    
}
