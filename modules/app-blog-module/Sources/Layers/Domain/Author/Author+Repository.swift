//
//  Author.Repository.Interface.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherDomain

extension Author.Repository {
    public protocol Interface: FeatherDomain.Repository {

        func find(
            id: String
        ) async throws -> Author.Model?

        func insert(
            _ model: Author.Model.New
        ) async throws -> Author.Model

        func update(
            _ model: Author.Model
        ) async throws -> Author.Model

        func delete(
            ids: [String]
        ) async throws -> [String]
    }
}
