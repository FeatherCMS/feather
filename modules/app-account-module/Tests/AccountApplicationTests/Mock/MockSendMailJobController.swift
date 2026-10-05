import FeatherApplication
import FeatherMail

actor MockSendMailJobController: SendMailJobController {
    private(set) var enqueueCallCount = 0
    private(set) var lastMail: Mail?

    var lastBody: String? {
        guard let lastMail else { return nil }
        switch lastMail.body {
        case .plainText(let body), .html(let body):
            return body
        }
    }

    func enqueue(_ mail: Mail) async throws {
        enqueueCallCount += 1
        lastMail = mail
    }
}
