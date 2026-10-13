import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewNewsletterIssueInteractor: Sendable {
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
}
