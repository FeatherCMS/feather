public import ContactModule
public import FeatherApplication

public import struct Foundation.Date

extension Form.Edit {
    public struct Output: DTO {
        public let id: String
        public let key: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let submitLabel: String
        public let redirectUrl: String?
        public let fields: [Form.Field]
        public let mails: [Form.Mail]
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            key: String,
            name: String,
            successMessage: String,
            failureMessage: String,
            submitLabel: String,
            redirectUrl: String?,
            fields: [Form.Field],
            mails: [Form.Mail],
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.successMessage = successMessage
            self.failureMessage = failureMessage
            self.submitLabel = submitLabel
            self.redirectUrl = redirectUrl
            self.fields = fields
            self.mails = mails
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
