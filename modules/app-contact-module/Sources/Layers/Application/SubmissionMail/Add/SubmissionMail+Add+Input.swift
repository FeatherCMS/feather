import ContactDomain
public import FeatherApplication

extension SubmissionMail {
    public enum Add {}
}

extension SubmissionMail.Add {
    public struct Input: DTO {
        public let mailFrom: String
        public let mailTo: String
        public let subject: String
        public let additionalHeaders: [String]
        public let messageBody: String

        public init(
            mailFrom: String,
            mailTo: String,
            subject: String,
            additionalHeaders: [String],
            messageBody: String
        ) {
            self.mailFrom = mailFrom
            self.mailTo = mailTo
            self.subject = subject
            self.additionalHeaders = additionalHeaders
            self.messageBody = messageBody
        }
    }
}
