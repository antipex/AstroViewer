//
//  PictureDetailView.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import SwiftUI

struct PictureDetailView: View {

    @StateObject var viewModel: PictureDetailViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if let displayable = viewModel.displayable {
                        AsyncImage(
                            url: displayable.imageUrl,
                            content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            },
                            placeholder: {
                                ProgressView()
                                    .tint(.white)
                            }
                        )
                        .frame(maxWidth: .infinity, minHeight: 96)

                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading) {
                                Text(displayable.title)
                                    .font(.headline)

                                Text(displayable.dateString)
                                    .font(.caption)
                            }

                            Text(displayable.detail)
                        }
                        .padding()
                    } else {
                        EmptyView()
                    }
                }
                .foregroundColor(.white)
            }
        }
        .background(Color.black)
    }
}

#Preview {
    PictureDetailView(viewModel: .debug)
}
