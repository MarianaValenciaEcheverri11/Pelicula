//
//  Home.swift
//  Peliculas
//
//  Created by Mariana Valencia Echeverri on 22/07/24.
//

import SwiftUI

protocol HomeViewDelegate {
    func displayMovies(with movies: [Movie])
}

struct Home: View {
    
    private struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let noResultsFoundText: String = "No results found"
        static let originalLanguage: String = "en"
        static let mainTitle: String = "Películas"
    }
    
    @State private var selectedSection: String = SectionType.popular.rawValue
    @State private var selectedFilter: String = FilterType.adult.rawValue
    @State private var searchText: String = .empty
    @State private var movies: [Movie] = []
    @State private var moviesFiltered: [Movie] = []
    private let allSectionTypes: [String] = SectionType.allCases.map { $0.rawValue }
    private let allFilterTypes: [String] = FilterType.allCases.map { $0.rawValue }
    
    var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            filter
            NavigationStack {
                moviesView
                Spacer()
                picker
            }
            .onChange(of: selectedSection, perform: { _ in
                displayMovies(with: movies)
            })
            .onChange(of: searchText, perform: { inputText in
                self.moviesFiltered = movies
                searchMovie(in: inputText)
            })
            .onChange(of: selectedFilter, perform: { _ in
                filterMovies()
            })
            .searchable(text: $searchText)

        }
        .onAppear(perform: onAppear)
    }
    
    private var moviesView: some View {
        ScrollView {
            moviesFiltered.count != .zero ? AnyView(getMoviesCells()) : AnyView(getNoResultsFoundLabel())
        }
        .navigationBarTitle(Constants.mainTitle, displayMode: .inline)
    }
    
    private var filter: some View {
        HStack(spacing: 8) {
            Spacer()
            Picker(String.empty, selection: $selectedFilter) {
                ForEach(allFilterTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
    
    private var picker: some View {
        Picker(String.empty, selection: $selectedSection) {
            ForEach(allSectionTypes, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        .frame(alignment: .bottom)
        .padding(.horizontal, Constants.horizontalPadding)
    }
    
    private func onAppear() {
        viewModel.view = self
        Task {
            do {
                await viewModel.viewDidLoad()
            }
        }
    }
    
    private func searchMovie(in inputText: String) {
        guard inputText != .empty else { return }
        let searchText = inputText.lowercased()
        self.moviesFiltered = self.movies.filter { movie in
            guard let title = movie.title else { return false }
            return title.lowercased().contains(searchText)
        }
    }
    
    private func getNoResultsFoundLabel() -> any View {
        Text(Constants.noResultsFoundText)
    }
    
    private func getMoviesCells() -> any View {
        ForEach (moviesFiltered, id: \.self) { movie in
            MovieCell(
                imageUrl: viewModel.getImageUrl(with: movie.backdropPath ?? .empty),
                title: movie.title ?? .empty)
            .padding(.horizontal, Constants.horizontalPadding)
            Divider()
                .background(Color.black)
        }
    }
    
    private func filterMovies() {
        switch FilterType(rawValue: selectedFilter) {
        case .originalLanguage:
            self.moviesFiltered = movies.filter { movie in
                return movie.originalLanguage == Constants.originalLanguage
            }
        case .adult:
            self.moviesFiltered = movies.filter { movie in
                return movie.adult ?? false
            }
        case .voteAverage:
            self.moviesFiltered = movies.sorted(by: { $0.voteAverage ?? 0 > $1.voteAverage ?? 0 })
        case .none:
            break
        }
    }
}

extension Home: HomeViewDelegate {
    
    func displayMovies(with movies: [Movie]) {
        self.movies = movies
        switch SectionType(rawValue: selectedSection) {
        case .popular:
            self.moviesFiltered = movies.sorted(by: { $0.popularity ?? 0 > $1.popularity ?? 0 })
        case .topRated:
            self.moviesFiltered = movies.sorted(by: { $0.voteCount ?? 0 > $1.voteCount ?? 0 })
        case .none:
            break
        }
    }
}
