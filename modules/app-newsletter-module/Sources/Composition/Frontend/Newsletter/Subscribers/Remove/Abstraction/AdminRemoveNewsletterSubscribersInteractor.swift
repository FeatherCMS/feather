import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterSubscribersInteractor: Sendable {
    func remove(ids: [String], campaignId: String?) async throws
}
