//
//  Article.Repository.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import NewsModule

extension Article {
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

            func removeCategory(
                id: String
            ) async throws

            func delete(
                ids: [String]
            ) async throws -> [String]
        }
    }
}
