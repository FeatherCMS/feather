//
//  AnalyticsInfrastructure+Tests.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AnalyticsModule
import FeatherDBAL
import Testing

@testable import AnalyticsInfrastructure

@Suite
struct AnalyticsInfrastructureTests {

    @Test
    func logTableSchemaDefinesColumnsPrimaryKeyAndIndexes() {
        let schema = Log.Table.tableCreationSchema

        #expect(schema.name == "analytics_log")
        #expect(
            schema.columns.map(\.name) == [
                "id", "account_id", "source", "method", "url", "headers",
                "ip", "path", "referer", "origin", "accept_language",
                "user_agent", "traffic_category", "language", "region",
                "os_name", "os_version", "browser_name", "browser_version",
                "engine_name", "engine_version", "device_vendor", "device_type",
                "device_model", "cpu", "response_code", "created_at",
                "updated_at",
            ]
        )
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.columns.first(where: { $0.name == "response_code" })?.type
                == .int32
        )
        #expect(
            schema.columns.first(where: { $0.name == "created_at" })?.type
                == .timestamp
        )
        #expect(
            schema.columns.first(where: { $0.name == "updated_at" })?.type
                == .timestamp
        )
        for column in [
            schema.columns.first(where: { $0.name == "created_at" }),
            schema.columns.first(where: { $0.name == "updated_at" }),
        ] {
            #expect(column?.constraints.contains {
                if case .notNull = $0 { true } else { false }
            } == true)
        }
        #expect(
            schema.columns.first(where: { $0.name == "source" })?.constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else { return false }
                    return actual == "backend_api"
                } == true
        )
        #expect(
            schema.columns.first(where: { $0.name == "traffic_category" })?
                .constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else { return false }
                    return actual == "human"
                } == true
        )
        #expect(
            schema.columns.first(where: { $0.name == "response_code" })?
                .constraints.contains {
                    if case .notNull = $0 { true } else { false }
                } == true
        )
        #expect(
            schema.indexes.map(\.name) == [
                "analytics_log_created_at_idx",
                "analytics_log_path_idx",
                "analytics_log_account_id_idx",
                "analytics_log_source_idx",
                "analytics_log_source_created_at_idx",
            ]
        )
    }
}
