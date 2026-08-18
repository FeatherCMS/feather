//
//  MenuItemRepository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol MenuItemRepository: Repository {

    func find(
        id: String
    ) async throws -> MenuItem?

    func insert(
        _ model: MenuItem.New
    ) async throws -> MenuItem

    func update(
        _ model: MenuItem
    ) async throws -> MenuItem

    func move(
        id: String,
        menuId: String,
        beforeItemId: String?
    ) async throws

    func delete(
        id: String
    ) async throws -> Bool
}
