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

extension Subscriber.Add {
    enum Interactor {}
}

extension Subscriber.Add.Interactor {
    protocol Interface: Sendable {
        func get() async throws -> Subscriber.Add.Model
        func post(form: Subscriber.Add.Form) async throws
            -> Subscriber.Add.Model
    }
}
