//
//  HomeViewModel.swift
//  Peliculas
//
//  Created by Mariana Valencia Echeverri on 23/07/24.
//

import Foundation
import UIKit

protocol HomeViewModelProtocol {
    func viewDidLoad() async
}

class HomeViewModel: HomeViewModelProtocol  {
    
    var view: HomeViewDelegate?
    var services = Services()

    func viewDidLoad() async {
        await getMovies()
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
