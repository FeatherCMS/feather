import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterIssueInteractor: Sendable {
    func remove(newsletterId: String, issueId: String) async throws
}
