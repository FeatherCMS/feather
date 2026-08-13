import Jobs

public struct EmailJobPayload: JobParameters {
    public static let jobName = "send_email"

    public let to: [String]
    public let from: String
    public let subject: String
    public let message: String

    public init(
        to: [String],
        from: String,
        subject: String,
        message: String
    ) {
        self.to = to
        self.from = from
        self.subject = subject
        self.message = message
    }
}
