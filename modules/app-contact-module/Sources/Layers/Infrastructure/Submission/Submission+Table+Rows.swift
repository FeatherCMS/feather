public import ContactModule
public import FeatherDBAL

public import struct Foundation.Date

extension Submission.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let formId: String
        public let values: String
        public let itemsSnapshot: String
        public let metadata: String?
        public let status: String

        enum CodingKeys: String, CodingKey {
            case id
            case formId = "form_id"
            case values
            case itemsSnapshot = "items_snapshot"
            case metadata
            case status
        }
    }
}

extension Submission.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let status: String

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Submission.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Submission.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let formId: String
        public let values: String
        public let itemsSnapshot: String
        public let metadata: String?
        public let status: String
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Submission.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let formId: String
        public let values: String
        public let itemsSnapshot: String
        public let metadata: String?
        public let status: String
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Submission.Table: DatabaseTableWithDelete {}
