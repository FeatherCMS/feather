import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterIssueDefaultInteractor:
    AdminAddNewsletterIssueInteractor
{
    let repository: AdminAddNewsletterIssueOpenAPIRepository
    func getAddNewsletterIssue(newsletterId: String) async throws
        -> AdminAddNewsletterIssueModel
    {
        .init(
            subject: "",
            content: "",
            scheduledAt: "",
            newsletterId: newsletterId,
            error: nil
        )
    }
    func postAddNewsletterIssue(
        newsletterId: String,
        payload: NewsletterIssueAddForm
    ) async throws -> AdminAddNewsletterIssueModel {
        do {
            try await repository.createIssue(
                newsletterId: newsletterId,
                form: payload
            )
            return .init(
                subject: "",
                content: "",
                scheduledAt: "",
                newsletterId: newsletterId,
                error: nil
            )
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                subject: payload.subject,
                content: payload.content,
                scheduledAt: payload.scheduledAt,
                newsletterId: newsletterId,
                error: error.errorDescription
            )
        }
    }
}
