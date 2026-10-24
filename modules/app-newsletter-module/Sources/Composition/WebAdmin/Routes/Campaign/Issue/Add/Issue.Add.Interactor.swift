import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Add {
    enum Interactor {}
}

extension Issue.Add.Interactor {
    protocol Interface: Sendable {
        func get(newsletterId: String) async throws -> Issue.Form.Model
        func add(
            newsletterId: String,
            payload: Issue.Form.Input
        ) async throws -> Issue.Form.Model
    }
}
