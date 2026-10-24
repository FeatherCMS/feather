package import ContactDomain
public import ContactModule

public import struct Foundation.Date

extension Form {
    public struct Mail: Sendable {
        public let id: String
        public let formId: String
        public let mailFrom: String
        public let mailTo: String
        public let subject: String
        public let additionalHeaders: [String]
        public let messageBody: String
        public let createdAt: Date
        public let updatedAt: Date

        package init(model: SubmissionMail.Model) {
            id = model.id
            formId = model.formId
            mailFrom = model.mailFrom
            mailTo = model.mailTo
            subject = model.subject
            additionalHeaders = model.additionalHeaders
            messageBody = model.messageBody
            createdAt = model.createdAt
            updatedAt = model.updatedAt
        }
    }
}

extension SubmissionMail.Model {
    var asFormMail: Form.Mail { .init(model: self) }
}
