//
//  HomeViewModel.swift
//  CountryListUIKit
//
//  Created by Abouzar Moradian on 10/2/24.
//

import Foundation
import Combine

protocol HomeViewModel{
    
    var dataPublisher: AnyPublisher<[CountryModel], Error> { get }
}

class HomeViewModelImpl: HomeViewModel {
    var dataPublisher: AnyPublisher<[CountryModel], Error>
    var cancellables = Set<AnyCancellable>()
    
    var apiClient: CombineAPIClient
    var apiRequest: APIRequest
    
    init(apiClient: CombineAPIClient, apiRequest: APIRequest) {
        self.apiClient = apiClient
        self.apiRequest = apiRequest
        
        // Initialize the dataPublisher with the API call
        self.dataPublisher = apiClient.publisher(apiRequest, modelType: [CountryModel].self)
    }
    
  
}
