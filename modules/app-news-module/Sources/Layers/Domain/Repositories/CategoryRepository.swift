//
//  CategoryRepository.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol CategoryRepository: Repository {

    func find(
        id: String
    ) async throws -> Category?

    func insert(
        _ model: Category.New
    ) async throws -> Category

    func update(
        _ model: Category
    ) async throws -> Category

    func delete(
        id: String
    ) async throws -> Bool
}
