//
//  APIClient.swift
//  CountryListUIKit
//
//  Created by Abouzar Moradian on 10/2/24.
//

import Foundation
import Combine

protocol CombineAPIClient{
    func publisher<T: APIRequest, P: Codable>(_ apiRequest: T, modelType: P.Type) -> AnyPublisher<P, Error>
    
}

class CountryAPIClient: CombineAPIClient{
    
    func publisher<T: APIRequest, P: Codable>(_ apiRequest: T, modelType: P.Type) -> AnyPublisher<P, Error>
 {
        
        let result = apiRequest.with(queryItems: [])
        switch result {
        case .success(let request):
            guard let url = request.url else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap({ data, response in
                    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                        throw URLError(.badServerResponse)
                    }
                    do{
                        return try decoder.decode(P.self, from: data) 
                    }catch{
                        print("failed to error: \(error)")
                        throw URLError(.badServerResponse)

                    }
                    
                })
                
                .eraseToAnyPublisher()
                
            
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
            
        }
        
    }
    
    
}

class MockCountryAPIClient<G: Codable>: CombineAPIClient{
    var mockData: [G]
    
    init(mockData: [G]) {
        self.mockData = mockData
    }
    
    func publisher<T: APIRequest, P: Codable>(_ apiRequest: T, modelType: P.Type) -> AnyPublisher<P, Error>{
        if [G].self == P.self {
            print("the types of P and G are the same")
            if let dataAsP = mockData as? P{
                return Just(dataAsP)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }else{
                return Fail(error: URLError(.cannotDecodeRawData)).eraseToAnyPublisher()
            }
        }
        print("the types of P and G are not the same")
       return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
}
