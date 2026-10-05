public import FeatherMail

public protocol SendMailJobController: Sendable {
    func enqueue(_ mail: Mail) async throws
}
