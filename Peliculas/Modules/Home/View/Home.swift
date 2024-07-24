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
    @State private var searchText: String = String.empty
    @State private var movies: [Movie] = []
    private let allSectionTypes: [String] = SectionType.allCases.map { $0.rawValue }
    private let allFilterTypes: [String] = FilterType.allCases.map { $0.rawValue }
    
    var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            filter
            searchEngine
            Spacer()
            picker
        }
        .onAppear(perform: onAppear)
    }
    
    private var searchEngine: some View {
        NavigationStack {
            ForEach (movies, id: \.self) { movie in
                Text(movie.title ?? .empty)
            }
        }
        .searchable(text: $searchText)
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
        self.movies = movies
        print(movies)
    }
}
