import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditNewsletterIssueInteractor: Sendable {
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    func update(
        newsletterId: String,
        issueId: String,
        form: NewsletterIssueAddForm
    ) async throws
}
