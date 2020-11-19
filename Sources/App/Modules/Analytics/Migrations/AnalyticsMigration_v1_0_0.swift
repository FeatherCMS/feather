//
//  AnalyticsMigration_v1_0_0.swift
//  Analytics
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

import Vapor
import Fluent

struct AnalyticsMigration_v1_0_0: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(AnalyticsLogModel.schema)
                .id()
                .field(AnalyticsLogModel.FieldKeys.date, .date, .required)
                .field(AnalyticsLogModel.FieldKeys.session, .string)
                .field(AnalyticsLogModel.FieldKeys.method, .string, .required)
                .field(AnalyticsLogModel.FieldKeys.url, .string, .required)
                .field(AnalyticsLogModel.FieldKeys.headers, .json, .required)
                .field(AnalyticsLogModel.FieldKeys.ip, .string)
                
                .field(AnalyticsLogModel.FieldKeys.path, .string, .required)
                .field(AnalyticsLogModel.FieldKeys.referer, .string)
                .field(AnalyticsLogModel.FieldKeys.origin, .string)
                .field(AnalyticsLogModel.FieldKeys.language, .string)
                .field(AnalyticsLogModel.FieldKeys.region, .string)
                
                .field(AnalyticsLogModel.FieldKeys.osName, .string)
                .field(AnalyticsLogModel.FieldKeys.osVersion, .string)
                .field(AnalyticsLogModel.FieldKeys.browserName, .string)
                .field(AnalyticsLogModel.FieldKeys.browserVersion, .string)
                .field(AnalyticsLogModel.FieldKeys.engineName, .string)
                .field(AnalyticsLogModel.FieldKeys.engineVersion, .string)
                .field(AnalyticsLogModel.FieldKeys.deviceVendor, .string)
                .field(AnalyticsLogModel.FieldKeys.deviceType, .string)
                .field(AnalyticsLogModel.FieldKeys.deviceModel, .string)
                .field(AnalyticsLogModel.FieldKeys.cpu, .string)
                .create(),
        ])
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(AnalyticsLogModel.schema).delete(),
        ])
    }
}
