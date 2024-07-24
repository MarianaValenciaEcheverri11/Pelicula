//
//  ServiceProtocol.swift
//  Peliculas
//
//  Created by Mariana Valencia Echeverri on 24/07/24.
//

import Foundation

protocol ServiceProtocol {
    func getMoviesAsync() async throws ->  MovieSet
    func getImageUrl(with path: String) -> String
}
