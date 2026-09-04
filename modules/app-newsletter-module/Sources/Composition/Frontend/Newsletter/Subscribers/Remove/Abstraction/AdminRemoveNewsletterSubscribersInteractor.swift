import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveNewsletterSubscribersInteractor: Sendable {
    func remove(ids: [String], campaignId: String?) async throws
}
