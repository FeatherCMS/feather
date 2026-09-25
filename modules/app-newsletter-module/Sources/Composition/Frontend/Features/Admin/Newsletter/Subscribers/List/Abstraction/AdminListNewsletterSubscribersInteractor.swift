import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterSubscribersInteractor: Sendable {
    func list(search: String?, campaignId: String?, page: Int) async throws
        -> AdminNewsletterSubscribersListModel
    func get(id: String) async throws -> AdminNewsletterSubscriberListItem
    func names(ids: [String]) async throws -> [String]
}
