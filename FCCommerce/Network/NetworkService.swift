//
//  NetworkService.swift
//  FCCommerce
//
//  Created by joe on 9/11/26.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case responseError
    case decodeError
    case serverError(statusCode: Int)
    case unknownError
}

class NetworkService {
    static let shared = NetworkService()
    private let homeURLString = "https://gist.github.com/iOSdvlprK/c08ac50d3654bd8e4f32137133e030ec/raw/home.json"
    private let favoriteURLString = "https://gist.github.com/iOSdvlprK/c08ac50d3654bd8e4f32137133e030ec/raw/favorite.json"
    private let productDetailURLString = "https://gist.github.com/iOSdvlprK/c08ac50d3654bd8e4f32137133e030ec/raw/product_detail.json"
    
    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.responseError
        }
        switch httpResponse.statusCode {
        case 200..<300:
            return data
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    func getHomeData() async throws -> HomeResponse {
        guard let url = URL(string: homeURLString) else { throw NetworkError.urlError }
        let data = try await fetchData(from: url)
        do {
            let decodeData = try JSONDecoder().decode(HomeResponse.self, from: data)
            return decodeData
        } catch {
            throw NetworkError.decodeError
        }
    }
    
    func getFavoriteData() async throws -> FavoriteResponse {
        guard let url = URL(string: favoriteURLString) else { throw NetworkError.urlError }
        let data = try await fetchData(from: url)
        do {
            let decodeData = try JSONDecoder().decode(FavoriteResponse.self, from: data)
            return decodeData
        } catch {
            throw NetworkError.decodeError
        }
    }
    
    func getProductDetailData() async throws -> ProductDetailResponse {
        guard let url = URL(string: productDetailURLString) else { throw NetworkError.urlError }
        let data = try await fetchData(from: url)
        do {
            let decodeData = try JSONDecoder().decode(ProductDetailResponse.self, from: data)
            return decodeData
        } catch {
            throw NetworkError.decodeError
        }
    }
}
