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
    }
    
    @State private var selectedSection: String = SectionType.popular.rawValue
    @State private var selectedFilter: String = FilterType.adult.rawValue
    @State private var searchText: String = .empty
    @State private var movies: [Movie] = []
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
            .onChange(of: selectedSection, perform: { newValue in
                displayMovies(with: movies)
            })
            .searchable(text: $searchText)

        }
        .onAppear(perform: onAppear)
    }
    
    private var moviesView: some View {
        ScrollView {
            ForEach (movies, id: \.self) { movie in
                MovieCell(
                    imageUrl: viewModel.getImageUrl(with: movie.backdropPath ?? .empty),
                    title: movie.title ?? .empty)
                .padding(.horizontal, Constants.horizontalPadding)
                Divider()
                    .background(Color.black)
            }
        }

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
}

extension Home: HomeViewDelegate {
    
    func displayMovies(with movies: [Movie]) {
        switch SectionType(rawValue: selectedSection) {
        case .popular:
            self.movies = movies.sorted(by: { $0.popularity ?? 0 > $1.popularity ?? 0 })
        case .topRated:
            self.movies = movies.sorted(by: { $0.voteCount ?? 0 > $1.voteCount ?? 0 })
        case .none:
            break
        }
    }
}
