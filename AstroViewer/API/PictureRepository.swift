//
//  PictureRepository.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import Foundation
import Combine

enum APIError: Error {
    case unknown
    case apiError(String)
}

protocol PictureRepositoryProtocol {
    func getPictures(startDate: Date, endDate: Date?) -> AnyPublisher<[Picture], APIError>
}

class PictureRepository: PictureRepositoryProtocol {

    func getPictures(startDate: Date, endDate: Date? = nil) -> AnyPublisher<[Picture], APIError> {
        guard var urlComponents = URLComponents(string: K.baseUrl + "/apod") else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.dateFormat
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: K.apiKey),
            URLQueryItem(name: "start_date", value: dateFormatter.string(from: startDate))
        ]

        if let endDate = endDate {
            urlComponents.queryItems?.append(URLQueryItem(name: "end_date", value: dateFormatter.string(from: endDate)))
        }

        let request = URLRequest(url: urlComponents.url!)

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { [weak self] data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }

                return self?.pictures(from: data) ?? []
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.apiError(error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }

    private func pictures(from data: Data) -> [Picture]? {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = K.dateFormat

        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let pictures = try? decoder.decode([Picture].self, from: data)
        return pictures
    }

}
