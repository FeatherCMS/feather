//
//  Settings.Repository.Interface.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain

extension Settings {
    public enum Repository {}
    }

    extension Settings.Repository {
    public protocol Interface: FeatherDomain.Repository {

        func get() async throws -> Settings.Model

        func update(
            _ model: Settings.Model
        ) async throws -> Settings.Model
    }
}
