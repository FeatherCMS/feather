//
//  AuthorRepository.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Domain

public protocol AuthorRepository: Repository {

    func find(
        id: String
    ) async throws -> Author?

    func insert(
        _ model: Author.New
    ) async throws -> Author

    func update(
        _ model: Author
    ) async throws -> Author

    func delete(
        id: String
    ) async throws -> Bool
}
