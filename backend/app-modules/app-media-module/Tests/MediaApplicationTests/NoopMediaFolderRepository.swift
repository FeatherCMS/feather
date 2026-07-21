//
//  NoopMediaFolderRepository.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 07. 16.

import MediaDomain

actor NoopMediaFolderRepository: MediaFolderRepository {
    func insert(
        _ model: MediaFolder.New
    ) async throws -> MediaFolder {
        _ = model
        throw MediaFolderRepositoryError.unused
    }

    func update(
        _ model: MediaFolder
    ) async throws -> MediaFolder {
        model
    }

    func find(
        id: String
    ) async throws -> MediaFolder? {
        _ = id
        return nil
    }

    func find(
        path: String
    ) async throws -> MediaFolder? {
        _ = path
        return nil
    }

    func list(
        parentId: String?
    ) async throws -> [MediaFolder] {
        _ = parentId
        return []
    }

    func listDescendants(
        path: String
    ) async throws -> [MediaFolder] {
        _ = path
        return []
    }

    func delete(
        id: String
    ) async throws -> Bool {
        _ = id
        return false
    }
}

private enum MediaFolderRepositoryError: Error {
    case unused
}
