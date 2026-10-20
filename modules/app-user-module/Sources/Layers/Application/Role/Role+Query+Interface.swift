//
//  Role.Query.Interface.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import UserModule

extension Role.Query {
    public protocol Interface: Sendable {

        func search(
            query: Role.Search.Input.Query
        ) async throws -> Role.Search.Output

        func getBy(
            id: String
        ) async throws -> Role.Detail.Output
    }
}
