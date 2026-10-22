//
//  Tag.Repository.Interface.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherDomain

extension Tag.Repository {
    public protocol Interface: FeatherDomain.Repository {

        func find(
            id: String
        ) async throws -> Tag.Model?

        func insert(
            _ model: Tag.Model.New
        ) async throws -> Tag.Model

        func update(
            _ model: Tag.Model
        ) async throws -> Tag.Model

        func delete(
            ids: [String]
        ) async throws -> [String]
    }
}
