//
//  Metadata+Repository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import WebModule

extension Metadata {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func find(
                id: String
            ) async throws -> Model?

            func find(
                slug: String
            ) async throws -> Model?

            func find(
                referenceType: String,
                referenceId: String
            ) async throws -> Model?

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

            func delete(
                ids: [String]
            ) async throws -> [String]

            func delete(
                referenceType: String,
                referenceIds: [String]
            ) async throws -> [String]
        }
    }
}
