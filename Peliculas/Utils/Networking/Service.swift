//
//  Service.swift
//  Peliculas
//
//  Created by Mariana Valencia Echeverri on 23/07/24.
//

import Foundation

enum MovieError: Error {
    case formatIncorrect
    case invalidUrl
}

struct Constants {
 
    struct Urls {
        static func getMovie(id: String) -> URL? {
            return URL(string: "\(Apis.BASE_API_URL)movie/\(id)?api_key=\(getApiKey())")
        }
        
        static func getMovies() -> URL? {
            return URL(string: "\(Apis.BASE_API_URL)discover/movie?api_key=\(getApiKey())")
        }
        
        static func getApiKey() -> String {
            ProcessInfo.processInfo.environment["API_KEY"] ?? .empty
        }
    }
}

class Services: ServiceProtocol {
    
    func getImageUrl(with path: String) -> String {
        Apis.BASE_API_URL_IMAGE + path
    }
    
    func getMoviesAsync() async throws ->  MovieSet {
        try await withCheckedThrowingContinuation { continuation in
            getMovies() { result in
                switch result {
                    case .success(let movies):
                        continuation.resume(returning: movies)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func getMovies(completion: @escaping (Result<MovieSet, MovieError>) -> Void) {
        let urlSession = URLSession.shared
        guard let url = Constants.Urls.getMovies() else {
            return completion(.failure(.invalidUrl))
        }
        urlSession.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let movies = try JSONDecoder().decode(MovieSet.self, from: data)
                    completion(.success(movies))
                }
            } catch {
                completion(.failure(.formatIncorrect))
            }
        }.resume()
    }
}
