public struct UserInvitationMailJobPayload: Codable, Sendable {
    public static let jobName = "send_user_invitation_email"

    public let email: String
    public let token: String

    public init(
        email: String,
        token: String
    ) {
        self.email = email
        self.token = token
    }
}
