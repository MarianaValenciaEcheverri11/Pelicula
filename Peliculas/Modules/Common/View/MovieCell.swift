//
//  MovieCell.swift
//  Peliculas
//
//  Created by Mariana Valencia Echeverri on 24/07/24.
//

import SwiftUI

struct MovieCell: View {
    
    private struct Constants {
        static let imageWidth: CGFloat = 120
        static let padding: CGFloat = 16
    }
    
    let imageUrl: String
    let title: String
    
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: imageUrl),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: Constants.imageWidth, maxHeight: Constants.imageWidth)
                },
                placeholder: {
                    ProgressView()
                }
            )
            Spacer()
            Text(title)
                .multilineTextAlignment(.trailing)
                .padding(.leading, Constants.padding)
        }
    }
}
