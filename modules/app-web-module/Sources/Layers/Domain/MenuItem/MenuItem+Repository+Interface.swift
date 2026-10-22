//
//  MenuItem.Repository.Interface.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain

extension MenuItem {
    public enum Repository {}
    }

    extension MenuItem.Repository {
    public protocol Interface: FeatherDomain.Repository {

        func find(
            id: String
        ) async throws -> MenuItem.Model?

        func insert(
            _ model: MenuItem.Model.New
        ) async throws -> MenuItem.Model

        func update(
            _ model: MenuItem.Model
        ) async throws -> MenuItem.Model

        func move(
            id: String,
            menuId: String,
            beforeItemId: String?
        ) async throws

        func delete(ids: [String]) async throws -> [String]
    }
}
