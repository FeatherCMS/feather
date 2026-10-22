public import ContactDomain
public import FeatherApplication

public import struct Foundation.Date

extension SubmissionMail {
    public enum Detail {}
}

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
    }
}
