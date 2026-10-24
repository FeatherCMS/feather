public import FeatherDBAL
public import struct Foundation.Date
public import AnalyticsModule

extension Log.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let accountId: String?
        public let source: String
        public let method: String
        public let url: String
        public let headers: String
        public let ip: String?
        public let path: String
        public let referer: String?
        public let origin: String?
        public let acceptLanguage: String?
        public let userAgent: String?
        public let trafficCategory: String
        public let language: String?
        public let region: String?
        public let osName: String?
        public let osVersion: String?
        public let browserName: String?
        public let browserVersion: String?
        public let engineName: String?
        public let engineVersion: String?
        public let deviceVendor: String?
        public let deviceType: String?
        public let deviceModel: String?
        public let cpu: String?
        public let responseCode: Int

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Log.Table.columns.createdAt] = .currentTimestamp
            values[Log.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Log.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let accountId: String?
        public let source: String
        public let method: String
        public let url: String
        public let headers: String
        public let ip: String?
        public let path: String
        public let referer: String?
        public let origin: String?
        public let acceptLanguage: String?
        public let userAgent: String?
        public let trafficCategory: String
        public let language: String?
        public let region: String?
        public let osName: String?
        public let osVersion: String?
        public let browserName: String?
        public let browserVersion: String?
        public let engineName: String?
        public let engineVersion: String?
        public let deviceVendor: String?
        public let deviceType: String?
        public let deviceModel: String?
        public let cpu: String?
        public let responseCode: Int
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Log.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let accountId: String?
        public let source: String
        public let method: String
        public let path: String
        public let ip: String?
        public let browserName: String?
        public let responseCode: Int
        public let createdAt: Date
    }
}
