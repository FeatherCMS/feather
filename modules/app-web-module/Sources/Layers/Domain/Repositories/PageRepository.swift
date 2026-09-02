//
//  PageRepository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol PageRepository: Repository {

    func find(
        id: String
    ) async throws -> Page?

    func insert(
        _ model: Page.New
    ) async throws -> Page

    func update(
        _ model: Page
    ) async throws -> Page

    func delete(ids: [String]) async throws -> [String]
}
