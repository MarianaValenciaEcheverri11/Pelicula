//
//  Movie.swift

//  Peliculas
//
//  Created by Mariana Valencia Echeverri on 24/07/24.
//

import Foundation

struct Movie: Decodable, Hashable {
    let id: Int
    let title: String
    let adult: Bool
    let backdropPath: String
    let originalLanguage: String
    let voteAverage: Double
    let popularity: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, adult, popularity
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
