//
//  SettingsRepository.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

public import AccountModule
public import FeatherDomain

extension Settings {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func get(userId: String) async throws -> Model

            func getOrCreate(userId: String) async throws -> Model

            func create(userId: String) async throws

            func update(_ model: Model) async throws -> Model

            func delete(userId: String) async throws
        }
    }
}
