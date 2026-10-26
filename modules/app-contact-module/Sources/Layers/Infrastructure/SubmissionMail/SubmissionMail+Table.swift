public import ContactModule
public import FeatherDBAL

public import struct Foundation.Date

extension SubmissionMail {
    public struct Table: DatabaseTable {
        public static let name = "contact_form_mail"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let formId = DatabaseTableColumn<String>(name: "form_id")
            public let mailFrom = DatabaseTableColumn<String>(name: "mail_from")
            public let mailTo = DatabaseTableColumn<String>(name: "mail_to")
            public let subject = DatabaseTableColumn<String>(name: "subject")
            public let additionalHeaders = DatabaseTableColumn<String>(
                name: "additional_headers"
            )
            public let messageBody = DatabaseTableColumn<String>(
                name: "message_body"
            )
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
