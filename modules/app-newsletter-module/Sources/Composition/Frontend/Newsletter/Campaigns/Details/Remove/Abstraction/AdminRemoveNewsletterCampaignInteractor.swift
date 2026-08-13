import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterCampaignInteractor: Sendable {
    func remove(id: String) async throws
    func remove(ids: [String]) async throws
}
