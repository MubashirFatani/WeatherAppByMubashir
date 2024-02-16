//
//  ApiServices.swift
//  WeatherApp
//
//  Created by Mubashir on 16/02/2024.
//

import Foundation
import UIKit

enum endPoint: CustomStringConvertible {
    case getCurrentWeatherData(lat: Double, lon: Double, appid: String)
    var description: String {
        switch self{
        case .getCurrentWeatherData(let lat, let lon, let appid):
            return("lat=\(lat)&lon=\(lon)&appid=\(appid)")
        }
    }
}
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    
}


typealias Parameters = [String: Any]
typealias HTTPHeaders = [String: String]


class APIServices: NSObject {
    static let shared = APIServices()
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    
    func performRequest<T: Codable>(endPoint: endPoint, method: HTTPMethod, params: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endPoint.description) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
       if let params = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Empty response data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
