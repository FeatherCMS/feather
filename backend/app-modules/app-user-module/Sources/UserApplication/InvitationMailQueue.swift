public protocol InvitationMailQueue: Sendable {

    func enqueue(
        email: String,
        token: String
    ) async throws
}
