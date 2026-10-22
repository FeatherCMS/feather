//
//  Post.Repository.Interface.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherDomain

extension Post.Repository {
    public protocol Interface: FeatherDomain.Repository {

        func find(
            id: String
        ) async throws -> Post.Model?

        func insert(
            _ model: Post.Model.New
        ) async throws -> Post.Model

        func update(
            _ model: Post.Model
        ) async throws -> Post.Model

        func removeAuthor(
            id: String
        ) async throws

        func removeTag(
            id: String
        ) async throws

        func delete(
            ids: [String]
        ) async throws -> [String]
    }
}
