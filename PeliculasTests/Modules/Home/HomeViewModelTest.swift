//
//  HomeViewModelTest.swift
//  PeliculasTests
//
//  Created by Mariana Valencia Echeverri on 24/07/24.
//

import XCTest
@testable import Peliculas

class HomeViewModelTest: XCTestCase {
    
    struct DummyData {
        static let imageUrl: String = "www.google.com"
    }
    
    var mockView: MockView!
    var mockServices: MockServices!
    var sut: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        mockView = MockView()
        mockServices = MockServices()
        sut = HomeViewModel()
        sut.view = mockView
        sut.services = mockServices
    }

    override func tearDown() {
        super.tearDown()
        mockView = nil
        mockServices = nil
        sut = nil
    }
    
    func testWhenViewDidLoadIsCalledThenServicesAreInvoket() async {
        // When
        await sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(mockServices.invocations, [.getMoviesAsync])
    }
    
    func testWhenGetImageUrlIsCalledThenServicesAreInvoket() async {
        // When
        let url = sut.getImageUrl(with: DummyData.imageUrl)
        
        // Then
        XCTAssertEqual(mockServices.invocations, [.getImageUrl])
        XCTAssertEqual(url, DummyData.imageUrl)
    }
}

extension HomeViewModelTest {
    
    class MockView: HomeViewDelegate {
        
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        var invocations: [Invocation] = []
        
        enum Invocation {
            case displayMovies
        }
        
        func displayMovies(with movies: [Movie]) {
            invocations.append(.displayMovies)
        }
    }
    
    class MockServices: ServiceProtocol {
        
        struct DummyData {
            static let imageUrl: String = "www.google.com"
            static let movieSet: MovieSet = MovieSet(results: [])
        }
        
        var invocations: [Invocation] = []
        
        enum Invocation {
            case getMoviesAsync
            case getImageUrl
        }
        
        func getMoviesAsync() async throws ->  MovieSet {
            invocations.append(.getMoviesAsync)
            return DummyData.movieSet
        }
        
        func getImageUrl(with path: String) -> String {
            invocations.append(.getImageUrl)
            return DummyData.imageUrl
        }
    }
}
