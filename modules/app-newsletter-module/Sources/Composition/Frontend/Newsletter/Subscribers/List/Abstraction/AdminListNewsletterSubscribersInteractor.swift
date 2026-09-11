import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterSubscribersInteractor: Sendable {
    func list(search: String?, campaignId: String?) async throws
        -> AdminNewsletterSubscribersListModel
}
