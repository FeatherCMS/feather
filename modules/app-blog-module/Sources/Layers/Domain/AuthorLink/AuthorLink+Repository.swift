//
//  AuthorLink.Repository.Interface.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherDomain

extension AuthorLink.Repository {
    public protocol Interface: FeatherDomain.Repository {

        func find(
            id: String
        ) async throws -> AuthorLink.Model?

        func insert(
            _ model: AuthorLink.Model.New
        ) async throws -> AuthorLink.Model

        func update(
            _ model: AuthorLink.Model
        ) async throws -> AuthorLink.Model

        func delete(ids: [String]) async throws -> [String]
    }
}
