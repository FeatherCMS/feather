public import FeatherDomain
public import SystemModule

//
//  SystemModule.Permission.Repository.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Permission {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {
            func insert(_ model: Model.New) async throws -> Model
            func update(_ model: Model) async throws -> Model
            func find(id: String) async throws -> Model?
            func find(key: String) async throws -> Model?
            func delete(ids: [String]) async throws
        }
    }
}
