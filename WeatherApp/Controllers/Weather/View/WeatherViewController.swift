//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 26.11.2023.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: - IBOutlet(s)
    
    @IBOutlet weak var lblDate: UILabel?
    @IBOutlet weak var lblCity: UILabel?
    @IBOutlet weak var lblUsername: UILabel?
    @IBOutlet weak var profileImage: UIImageView?
    @IBOutlet weak var lblWeatherDescription: UILabel?
    @IBOutlet weak var imgWeatherStatusPic: UIImageView?
    
    @IBOutlet weak var btnForecastSegment: UISegmentedControl?
    @IBOutlet weak var weatherCollectionViewList: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSegmentAction(_ sender: UISegmentedControl) {
    }
    
}




