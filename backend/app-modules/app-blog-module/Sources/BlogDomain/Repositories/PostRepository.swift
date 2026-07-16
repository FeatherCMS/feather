//
//  PostRepository.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Domain

public protocol PostRepository: Repository {

    func find(
        id: String
    ) async throws -> Post?

    func insert(
        _ model: Post.New
    ) async throws -> Post

    func update(
        _ model: Post
    ) async throws -> Post

    func removeAuthor(
        id: String
    ) async throws

    func removeTag(
        id: String
    ) async throws

    func delete(
        id: String
    ) async throws -> Bool
}
