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

        enum CodingKeys: String, CodingKey {
            case id
            case formId = "form_id"
            case mailFrom = "mail_from"
            case mailTo = "mail_to"
            case subject
            case additionalHeaders = "additional_headers"
            case messageBody = "message_body"
        }
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case formId = "form_id"
            case mailFrom = "mail_from"
            case mailTo = "mail_to"
            case subject = "subject"
            case additionalHeaders = "additional_headers"
            case messageBody = "message_body"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case formId = "form_id"
            case mailFrom = "mail_from"
            case mailTo = "mail_to"
            case subject = "subject"
            case additionalHeaders = "additional_headers"
            case messageBody = "message_body"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}
extension SubmissionMail.Table: DatabaseTableWithDelete {}
