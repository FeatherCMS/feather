//
//  Menu+Repository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import WebModule

extension Menu {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func find(
                id: String
            ) async throws -> Menu.Model?

            func find(
                key: String
            ) async throws -> Menu.Model?

            func insert(
                _ model: Menu.Model.New
            ) async throws -> Menu.Model

            func update(
                _ model: Menu.Model
            ) async throws -> Menu.Model

            func delete(
                ids: [String]
            ) async throws -> [String]
        }
    }
}
