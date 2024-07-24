//
//  HomeViewModel.swift
//  Peliculas
//
//  Created by Mariana Valencia Echeverri on 23/07/24.
//

import Foundation

protocol HomeViewModelProtocol {
    func viewDidLoad() async
    func getImageUrl(with path: String) -> String
}

class HomeViewModel: HomeViewModelProtocol  {
    
    var view: HomeViewDelegate?
    var services: ServiceProtocol = Services()

    func viewDidLoad() async {
        await getMovies()
    }
    
    func getImageUrl(with path: String) -> String {
        services.getImageUrl(with: path)
    }
}

extension HomeViewModel {
    
    func getMovies() async {
        do {
            let movies = try await services.getMoviesAsync()
            DispatchQueue.main.async {
                self.view?.displayMovies(with: movies.results)
            }
        } catch {
            print(error)
        }
    }
}
