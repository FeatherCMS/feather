import AnalyticsModule
import FeatherDBAL

extension Log.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(name: columns.accountId.name, type: .string),
                .init(
                    name: columns.source.name,
                    type: .string,
                    constraints: [.notNull, .default(.value("backend_api"))]
                ),
                .init(
                    name: columns.method.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.url.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.headers.name,
                    type: .text,
                    constraints: [.notNull]
                ),
                .init(name: columns.ip.name, type: .string),
                .init(
                    name: columns.path.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(name: columns.referer.name, type: .string),
                .init(name: columns.origin.name, type: .string),
                .init(name: columns.acceptLanguage.name, type: .string),
                .init(name: columns.userAgent.name, type: .string),
                .init(
                    name: columns.trafficCategory.name,
                    type: .string,
                    constraints: [.default(.value("human"))]
                ),
                .init(name: columns.language.name, type: .string),
                .init(name: columns.region.name, type: .string),
                .init(name: columns.osName.name, type: .string),
                .init(name: columns.osVersion.name, type: .string),
                .init(name: columns.browserName.name, type: .string),
                .init(name: columns.browserVersion.name, type: .string),
                .init(name: columns.engineName.name, type: .string),
                .init(name: columns.engineVersion.name, type: .string),
                .init(name: columns.deviceVendor.name, type: .string),
                .init(name: columns.deviceType.name, type: .string),
                .init(name: columns.deviceModel.name, type: .string),
                .init(name: columns.cpu.name, type: .string),
                .init(
                    name: columns.responseCode.name,
                    type: .int32,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.createdAt.name,
                    type: .timestamp,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.updatedAt.name,
                    type: .timestamp,
                    constraints: [.notNull]
                ),
            ],
            constraints: [
                .primaryKey([.init(name: columns.id.name, type: .string)])
            ],
            indexes: [
                .init(
                    name: "analytics_log_created_at_idx",
                    columns: [
                        .init(name: columns.createdAt.name, type: .timestamp)
                    ]
                ),
                .init(
                    name: "analytics_log_path_idx",
                    columns: [.init(name: columns.path.name, type: .string)]
                ),
                .init(
                    name: "analytics_log_account_id_idx",
                    columns: [
                        .init(name: columns.accountId.name, type: .string)
                    ]
                ),
                .init(
                    name: "analytics_log_source_idx",
                    columns: [.init(name: columns.source.name, type: .string)]
                ),
                .init(
                    name: "analytics_log_source_created_at_idx",
                    columns: [
                        .init(name: columns.source.name, type: .string),
                        .init(name: columns.createdAt.name, type: .timestamp),
                    ]
                ),
            ]
        )
    }
}
