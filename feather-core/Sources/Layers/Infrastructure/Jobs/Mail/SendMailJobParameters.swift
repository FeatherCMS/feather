public import Jobs

public struct SendMailJobParameters: JobParameters {
    public static let jobName = "send_mail"

    public enum ContentType: String, Codable, Sendable {
        case plainText
        case html
    }

    public let from: String
    public let to: [String]
    public let subject: String
    public let additionalHeaders: [String]
    public let body: String
    public let contentType: ContentType

    public init(
        from: String,
        to: [String],
        subject: String,
        additionalHeaders: [String],
        body: String,
        contentType: ContentType
    ) {
        self.from = from
        self.to = to
        self.subject = subject
        self.additionalHeaders = additionalHeaders
        self.body = body
        self.contentType = contentType
    }
}
