import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterIssueInteractor: Sendable {
    func get(newsletterId: String, issueId: String) async throws
        -> NewAdminRemoveItemContext
    func remove(newsletterId: String, issueId: String) async throws
}
