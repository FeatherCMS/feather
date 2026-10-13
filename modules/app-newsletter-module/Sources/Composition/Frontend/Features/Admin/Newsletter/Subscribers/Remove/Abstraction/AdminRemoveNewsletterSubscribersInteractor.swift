import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterSubscribersInteractor: Sendable {
    func names(ids: [String]) async throws -> [String]
    func remove(ids: [String], campaignId: String?) async throws
}
