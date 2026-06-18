public struct MailAddress: Sendable, Equatable, Hashable {
    public var email: String
    public var name: String?

    public init(_ email: String, name: String? = nil) {
        self.email = email
        self.name = name
    }
}

public struct MailMessage: Sendable, Equatable, Hashable {
    public var from: MailAddress
    public var to: [MailAddress]
    public var subject: String
    public var body: String

    public init(
        from: MailAddress,
        to: [MailAddress],
        subject: String,
        body: String
    ) {
        self.from = from
        self.to = to
        self.subject = subject
        self.body = body
    }
}

public protocol MailSender: Sendable {
    func send(
        _ message: MailMessage
    ) async throws
}
