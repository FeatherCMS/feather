import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterIssueInteractor: Sendable {
    func remove(newsletterId: String, issueId: String) async throws
}
