import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import NewsletterApplication
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Remove {
    enum Interactor {}
}

extension Subscriber.Remove.Interactor {
    protocol Interface: Sendable {
        func remove(ids: [String], campaignId: String?) async throws
    }
}
