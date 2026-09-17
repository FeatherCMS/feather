//
//  MediaAssetQueries.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

public protocol MediaAssetQueries: Sendable {
    func find(
        id: String
    ) async throws -> MediaAssetDetail
    func resolve(
        ids: [String],
        variants: [String]?
    ) async throws -> MediaAssetResolve
    func list(
        query: MediaAssetList.Query
    ) async throws -> MediaAssetList
    func count(
        query: MediaAssetList.Query
    ) async throws -> Int
}
