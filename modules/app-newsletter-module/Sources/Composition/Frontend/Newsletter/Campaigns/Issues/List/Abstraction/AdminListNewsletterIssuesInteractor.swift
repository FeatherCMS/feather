import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListNewsletterIssuesInteractor: Sendable {
    func list(newsletterId: String) async throws
        -> [AdminNewsletterIssueItem]
}
