//
//  AuthorLink+Repository.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherDomain

extension AuthorLink {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func find(
                id: String
            ) async throws -> Model?

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

            func delete(ids: [String]) async throws -> [String]
        }
    }
}
