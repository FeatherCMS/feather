import FeatherDomain

import struct Foundation.Date

public struct SubmissionMail: Model {
    public struct New: Sendable {
        public let formId: String
        public let mailFrom: String
        public let mailTo: String
        public let subject: String
        public let additionalHeaders: String
        public let messageBody: String

        public init(
            formId: String,
            mailFrom: String,
            mailTo: String,
            subject: String,
            additionalHeaders: String,
            messageBody: String
        ) {
            self.formId = formId
            self.mailFrom = mailFrom
            self.mailTo = mailTo
            self.subject = subject
            self.additionalHeaders = additionalHeaders
            self.messageBody = messageBody
        }
    }

    public let id: String
    public let formId: String
    public let mailFrom: String
    public let mailTo: String
    public let subject: String
    public let additionalHeaders: String
    public let messageBody: String
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        formId: String,
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: String,
        messageBody: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.formId = formId
        self.mailFrom = mailFrom
        self.mailTo = mailTo
        self.subject = subject
        self.additionalHeaders = additionalHeaders
        self.messageBody = messageBody
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
