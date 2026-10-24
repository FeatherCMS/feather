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

extension Subscriber.List {
    enum Interactor {}
}

extension Subscriber.List.Interactor {
    protocol Interface: Sendable {
        func list(search: String?, campaignId: String?, page: Int) async throws
            -> Subscriber.List.Model
        func get(id: String) async throws -> Subscriber.List.Model.Item
    }
}
