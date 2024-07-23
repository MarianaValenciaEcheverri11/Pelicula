//
//  Home.swift
//  Peliculas
//
//  Created by Mariana Valencia Echeverri on 22/07/24.
//

import SwiftUI

struct Home: View {
    
    private struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let filterTitle: String = "Filtrar"
    }
    
    @State private var selectedSection: String = SectionType.popular.rawValue
    @State private var searchText: String = String.empty
    private let allSectionTypes: [String] = SectionType.allCases.map { $0.rawValue }

      var body: some View {
          VStack(spacing: .zero) {
              filter
              searchEngine
              Spacer()
              picker
          }
      }
    
    private var searchEngine: some View {
        NavigationStack {
            Text("Pelicula de\(searchText)")
        }
        .searchable(text: $searchText)
    }
    
    private var filter: some View {
        HStack(spacing: 8) {
            Spacer()
            Text(Constants.filterTitle)
                .foregroundColor(.blue)
                .onTapGesture {
                    
                }
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
}
