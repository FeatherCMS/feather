//
//  Invitation+Repository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AccountModule
public import FeatherDomain

extension Invitation {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func findBy(id: String) async throws -> Model?

            func findBy(token: String) async throws -> Model?

            func insert(_ model: Model.New) async throws
                -> Model

            func update(_ model: Model) async throws
                -> Model

            func delete(ids: [String]) async throws -> [String]
        }
    }
}
