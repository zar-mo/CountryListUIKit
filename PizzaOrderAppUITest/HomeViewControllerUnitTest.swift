//
//  HomeViewControllerUnitTest.swift
//  PizzaOrderAppUITest
//
//  Created by Abouzar Moradian on 10/2/24.
//

import XCTest
import Combine

@testable import CountryListUIKit

final class HomeViewControllerUnitTest: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    override func setUpWithError() throws {
        cancellables.removeAll()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        //given
        let apiRequest = CountryAPIRequest()
        let mockData = [
            CountryModel(capital: "DC", code: "", currency: Currency(code: "", name: "", symbol: ""), flag: "", language: Language(code: "", name: ""), name: "United State of America", region: ""),
            CountryModel(capital: "Berlin", code: "", currency: Currency(code: "", name: "", symbol: ""), flag: "", language: Language(code: "", name: ""), name: "Germany", region: "")
        ]
        let mockApiClient = MockCountryAPIClient(mockData: mockData)
        let viewModel = HomeViewModelImpl(apiClient: mockApiClient, apiRequest: apiRequest)
        let viewController = HomeViewController()
        
        //when
        //viewController.viewModel = viewModel
        
        // Load the view to trigger viewDidLoad and Combine subscription
        //_ = viewController.view
        
        let expectation = XCTestExpectation(description: "Data loaded from viewModel")
        //then
        // Wait for the Combine pipeline to finish and update the countries array
        viewModel.dataPublisher
            .sink { completion in
                switch completion{
                case .finished:
                    print("finished")
                case .failure(let error):
                    XCTFail("Failed to publish: \(error)")
                }
            } receiveValue: { countries in
                print(countries)
                XCTAssertEqual(countries, mockData)
                //XCTAssertEqual(viewController.countries, mockData)
                expectation.fulfill()

            }
            .store(in: &cancellables)
        
        // Wait for expectations to be fulfilled
            wait(for: [expectation], timeout: 1.0)

        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
