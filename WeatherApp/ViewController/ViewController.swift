//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mubashir on 16/02/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var getCurrentDataObj: CurrentDataResponse?
    
    @IBOutlet weak var lblTemperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       callJSONData()
    }
    
    func callJSONData(){
        let latitude: Double = 24.8607
        let longitude: Double = 67.0011
        let appID: String = "1f2a4aad91907c494d482ebd59e32dfc"
        
        APIServices.shared.performRequest(endPoint: endPoint.getCurrentWeatherData(lat: latitude, lon: longitude, appid: appID), method: .get) { [self] (result: Result<CurrentDataResponse, Error>) in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    self.getCurrentDataObj = data
                    self.updateUI()
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func updateUI() {
           if let temperature = getCurrentDataObj?.main.temp {
               let temperatureInCelsius = temperature - 273.15
               let formattedTemperature = String(format: "%.2f", temperatureInCelsius)
               lblTemperature.text = "\(formattedTemperature) °C"
           } else {
               lblTemperature.text = "Temperature data not available"
           }
       }
}

