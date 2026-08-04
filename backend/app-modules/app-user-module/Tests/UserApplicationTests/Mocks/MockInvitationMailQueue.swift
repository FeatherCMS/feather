import UserApplication

actor MockInvitationMailQueue: InvitationMailQueue {
    private(set) var enqueueCallCount = 0
    private(set) var lastEmail: String?
    private(set) var lastToken: String?

    func enqueue(
        email: String,
        token: String
    ) async throws {
        enqueueCallCount += 1
        lastEmail = email
        lastToken = token
    }
}
