import ContactDomain
public import ContactModule
public import FeatherApplication

public import struct Foundation.Date

extension SubmissionMail.Detail {
    public struct Output: DTO {
        public let id: String
        public let formId: String
        public let mailFrom: String
        public let mailTo: String
        public let subject: String
        public let additionalHeaders: [String]
        public let messageBody: String
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            formId: String,
            mailFrom: String,
            mailTo: String,
            subject: String,
            additionalHeaders: [String],
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
}

extension SubmissionMail.Model {
    var asDetail: SubmissionMail.Detail.Output {
        .init(
            id: id,
            formId: formId,
            mailFrom: mailFrom,
            mailTo: mailTo,
            subject: subject,
            additionalHeaders: additionalHeaders,
            messageBody: messageBody,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
