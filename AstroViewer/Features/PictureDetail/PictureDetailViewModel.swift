//
//  PictureDetailViewModel.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation
import Combine

final class PictureDetailViewModel: ObservableObject {

    @Published var displayable: PictureDetailDisplayable?

    init(picture: Picture?) {
        if let picture {
            displayable = PictureDetailDisplayable(
                title: picture.title,
                detail: picture.explanation,
                copyright: picture.copyright,
                imageUrl: picture.hdurl,
                dateString: picture.date
            )
        }
    }
}

extension PictureDetailViewModel {

    enum State {
        case initial
        case loading
        case loaded
        case error(message: String)
    }
}

extension PictureDetailViewModel {

    static var debug: PictureDetailViewModel {
        let viewModel = PictureDetailViewModel(picture: nil)

        viewModel.displayable = PictureDetailDisplayable(
            title: "Palomar 6: Globular Star Cluster",
            detail: "Why can we see the entire face of this Moon?  When the Moon is in a crescent phase, only part of it appears directly illuminated by the Sun.  The answer is earthshine, also known as earthlight and the da Vinci glow.  The reason is that the rest of the Earth-facing Moon is slightly illuminated by sunlight first reflected from the Earth.  Since the Earth appears near full phase from the Moon -- when the Moon appears as a slight crescent from the Earth -- earthshine is then near its brightest.  Featured here in combined, consecutively-taken, HDR images taken earlier this month, a rising earthshine Moon was captured passing slowly near the planet Venus, the brightest spot near the image center.  Just above Venus is the star Dschubba (catalogued as Delta Scorpii), while the red star on the far left is Antares. The celestial show is visible through scenic cloud decks. In the foreground are the lights from Palazzolo Acreide, a city with ancient historical roots in Sicily, Italy.",
            copyright: "\nDario Giannobile",
            imageUrl: URL(string: "https://apod.nasa.gov/apod/image/2110/EarthshineSky_Giannobile_1212.jpg")!,
            dateString: "2021-10-19"
        )

        return viewModel
    }
}
