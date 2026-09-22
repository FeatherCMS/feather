import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterCampaignInteractor: Sendable {
    func names(ids: [String]) async throws -> [String]
    func remove(id: String) async throws
    func remove(ids: [String]) async throws
}
