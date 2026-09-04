import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddNewsletterIssueInteractor: Sendable {
    func getAddNewsletterIssue(newsletterId: String) async throws
        -> AdminAddNewsletterIssueModel
    func postAddNewsletterIssue(
        newsletterId: String,
        payload: NewsletterIssueAddForm
    ) async throws -> AdminAddNewsletterIssueModel
}
