import FeatherApplication
import FeatherContracts

public struct SubmissionMailInput: DTO {
    public let mailFrom: String
    public let mailTo: String
    public let subject: String
    public let additionalHeaders: String
    public let messageBody: String

    public init(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: String,
        messageBody: String
    ) {
        self.mailFrom = mailFrom
        self.mailTo = mailTo
        self.subject = subject
        self.additionalHeaders = additionalHeaders
        self.messageBody = messageBody
    }
}
