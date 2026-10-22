import ContactDomain
public import ContactModule
public import FeatherApplication

public import struct Foundation.Date

extension Form {
    public enum Detail {}
}

extension Form.Detail {
    public struct Output: DTO {
        public let id: String
        public let key: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let fields: [FormField.Detail.Output]
        public let mails: [SubmissionMail.Detail.Output]
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            key: String,
            name: String,
            successMessage: String,
            failureMessage: String,
            redirectUrl: String?,
            fields: [FormField.Detail.Output],
            mails: [SubmissionMail.Detail.Output],
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.successMessage = successMessage
            self.failureMessage = failureMessage
            self.redirectUrl = redirectUrl
            self.fields = fields
            self.mails = mails
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
