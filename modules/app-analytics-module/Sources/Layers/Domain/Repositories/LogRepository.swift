//
//  Log.Repository.Interface.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import AnalyticsModule

extension Log {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func insert(
                _ model: Model.New
            ) async throws -> Model
        }
    }
}
