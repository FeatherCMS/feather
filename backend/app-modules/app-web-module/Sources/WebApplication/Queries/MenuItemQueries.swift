//
//  File.swift
//  app-redirect-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol MenuItemQueries: Sendable {

    func find(
        id: String
    ) async throws -> MenuItemDetail

    func list(
        menuId: String,
        query: MenuItemList.Query
    ) async throws -> MenuItemList

    func count(
        menuId: String,
        query: MenuItemList.Query
    ) async throws -> Int
}
