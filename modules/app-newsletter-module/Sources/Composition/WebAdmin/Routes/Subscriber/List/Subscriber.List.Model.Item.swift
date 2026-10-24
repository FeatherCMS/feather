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

extension Subscriber.List.Model {
    struct Item: Sendable {
        let id: String
        let email: String
        let name: String
        let newsletters: [Membership]
    }
}
