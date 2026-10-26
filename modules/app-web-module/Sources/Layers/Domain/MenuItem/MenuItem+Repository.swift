//
//  MenuItem+Repository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import WebModule

extension MenuItem {
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

            func move(
                id: String,
                menuId: String,
                beforeItemId: String?
            ) async throws

            func delete(ids: [String]) async throws -> [String]
        }
    }
}
