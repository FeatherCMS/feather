//
//  MediaFolderQueries.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

public protocol MediaFolderQueries: Sendable {
    func find(
        id: String
    ) async throws -> MediaFolderDetail
    func list(
        query: MediaFolderList.Query
    ) async throws -> MediaFolderList
}
