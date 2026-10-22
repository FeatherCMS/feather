//
//  Settings.Query.Interface.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import WebModule

extension Settings.Detail {
    public enum Query {
        public protocol Interface: Sendable {

            func get() async throws -> Settings.Detail.Output
        }
    }
}
