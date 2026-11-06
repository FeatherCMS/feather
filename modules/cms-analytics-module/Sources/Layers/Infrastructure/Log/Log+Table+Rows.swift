public import AnalyticsModule
public import FeatherDBAL

public import struct Foundation.Date

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

        enum CodingKeys: String, CodingKey {
            case id
            case accountId = "account_id"
            case source
            case method
            case url
            case headers
            case ip
            case path
            case referer
            case origin
            case acceptLanguage = "accept_language"
            case userAgent = "user_agent"
            case trafficCategory = "traffic_category"
            case language
            case region
            case osName = "os_name"
            case osVersion = "os_version"
            case browserName = "browser_name"
            case browserVersion = "browser_version"
            case engineName = "engine_name"
            case engineVersion = "engine_version"
            case deviceVendor = "device_vendor"
            case deviceType = "device_type"
            case deviceModel = "device_model"
            case cpu
            case responseCode = "response_code"
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case accountId = "account_id"
            case source = "source"
            case method = "method"
            case url = "url"
            case headers = "headers"
            case ip = "ip"
            case path = "path"
            case referer = "referer"
            case origin = "origin"
            case acceptLanguage = "accept_language"
            case userAgent = "user_agent"
            case trafficCategory = "traffic_category"
            case language = "language"
            case region = "region"
            case osName = "os_name"
            case osVersion = "os_version"
            case browserName = "browser_name"
            case browserVersion = "browser_version"
            case engineName = "engine_name"
            case engineVersion = "engine_version"
            case deviceVendor = "device_vendor"
            case deviceType = "device_type"
            case deviceModel = "device_model"
            case cpu = "cpu"
            case responseCode = "response_code"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case accountId = "account_id"
            case source = "source"
            case method = "method"
            case path = "path"
            case ip = "ip"
            case browserName = "browser_name"
            case responseCode = "response_code"
            case createdAt = "created_at"
        }
    }
}
