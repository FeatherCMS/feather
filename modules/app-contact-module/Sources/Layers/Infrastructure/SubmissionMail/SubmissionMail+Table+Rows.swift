public import ContactModule
public import FeatherDBAL
public import struct Foundation.Date

extension SubmissionMail.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let formId: String
        public let mailFrom: String
        public let mailTo: String
        public let subject: String
        public let additionalHeaders: String
        public let messageBody: String
    }
}

extension SubmissionMail.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let formId: String
        public let mailFrom: String
        public let mailTo: String
        public let subject: String
        public let additionalHeaders: String
        public let messageBody: String
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension SubmissionMail.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let formId: String
        public let mailFrom: String
        public let mailTo: String
        public let subject: String
        public let additionalHeaders: String
        public let messageBody: String
        public let createdAt: Date
        public let updatedAt: Date
    }
}
extension SubmissionMail.Table: DatabaseTableWithDelete {}
