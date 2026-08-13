import FeatherApplication
import FeatherContracts

actor MockMailSender: MailSender {
    private(set) var sendCallCount = 0
    private(set) var lastMessage: MailMessage?

    func send(
        _ message: MailMessage
    ) async throws {
        sendCallCount += 1
        lastMessage = message
    }
}
