//
//  ContentView.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import SwiftUI

struct PictureListView: View {

    @StateObject var viewModel: PictureListViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Astronomy Picture of the Day")
                        .font(.headline)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(viewModel.displayables) { displayable in
                                NavigationLink {
                                    appCoordinator.pictureDetailView(for: displayable.picture)
                                        .toolbarBackground(.hidden, for: .navigationBar)
                                } label: {
                                    PictureListItem(title: displayable.title, imageUrl: displayable.imageUrl)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .frame(height: 64)
                                }
                            }
                        }
                    }
                    .padding()
                }

                switch viewModel.state {
                case .error(message: let message):
                    Text("Error: \(message)")
                case .loading:
                    ProgressView()
                        .tint(.white)
                default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
            .background(Color.black)
        }
        .tint(.white)
    }
}

struct PictureListItem: View {

    let title: String
    let imageUrl: URL?

    var body: some View {
        HStack(spacing: 5) {
            AsyncImage(
                url: imageUrl,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 120)
                },
                placeholder: {
                    ProgressView()
                        .tint(.white)
                }
            )

            Text(title)
        }
    }

}

#Preview {
    PictureListView(viewModel: PictureListViewModel())
}
