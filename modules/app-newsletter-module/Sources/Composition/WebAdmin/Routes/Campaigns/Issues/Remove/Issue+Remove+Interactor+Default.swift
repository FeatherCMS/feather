import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Issue.Remove.Interactor {
    struct Default: Interface {
        let repository: Issue.Remove.Repository.OpenAPI

        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> AdminRemoveItemContext {
            let issue = try await repository.get(
                newsletterId: newsletterId,
                issueId: issueId
            )
            return .init(id: issueId, label: issue.subject)
        }

        func remove(newsletterId: String, issueId: String) async throws {
            try await repository.remove(
                newsletterId: newsletterId,
                issueId: issueId
            )
        }
    }
}
