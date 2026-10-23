//
//  Page.Repository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import WebModule

extension Page {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func find(
                id: String
            ) async throws -> Page.Model?

            func insert(
                _ model: Page.Model.New
            ) async throws -> Page.Model

            func update(
                _ model: Page.Model
            ) async throws -> Page.Model

            func delete(ids: [String]) async throws -> [String]
        }
    }
}
