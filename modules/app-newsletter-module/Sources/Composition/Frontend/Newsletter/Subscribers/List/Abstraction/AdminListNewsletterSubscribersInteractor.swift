import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListNewsletterSubscribersInteractor: Sendable {
    func list(search: String?, campaignId: String?) async throws
        -> AdminNewsletterSubscribersListModel
}
