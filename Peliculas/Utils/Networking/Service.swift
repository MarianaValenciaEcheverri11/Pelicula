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

struct Constans {
    struct Urls {
        static func getMovie(id: String) -> URL? {
            return URL(string: "\(Apis.BASE_API_URL)movie/\(id)?api_key=c1bedc54a1f90699c12c699ea882a9a1")
        }
        
        static func getMovies() -> URL? {
            return URL(string: "\(Apis.BASE_API_URL)discover/movie?api_key=c1bedc54a1f90699c12c699ea882a9a1")
        }
    }
}


class Services {
    
    func getMovieAsync(id: String) async throws -> Movie {
        try await withCheckedThrowingContinuation { continuation in
            getMovie(id: id) { result in
                switch result {
                    case .success(let movie):
                        continuation.resume(returning: movie)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getMovie(id: String, completion: @escaping (Result<Movie, MovieError>) -> Void) {
        let urlSession = URLSession.shared
        guard let url = Constans.Urls.getMovie(id: id) else {
            return completion(.failure(.invalidUrl))
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    completion(.success(movie))

                }
            } catch {
                completion(.failure(.formatIncorrect))
            }
        }.resume()
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
    
    func getMovies(completion: @escaping (Result<MovieSet, MovieError>) -> Void) {
        let urlSession = URLSession.shared
        guard let url = Constans.Urls.getMovies() else {
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
    
    func getImageUrl(with path: String) -> String {
        Apis.BASE_API_URL_IMAGE + path
    }
}
