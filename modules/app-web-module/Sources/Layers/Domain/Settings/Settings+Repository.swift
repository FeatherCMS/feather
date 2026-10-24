//
//  Settings+Repository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import WebModule

extension Settings {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func get() async throws -> Settings.Model

            func update(
                _ model: Settings.Model
            ) async throws -> Settings.Model
        }
    }
}
