import NewsletterApplication
import NewsletterModule

extension Issue.Edit.Interactor {
    struct Default: Interface {
        let repository: any Issue.Edit.Repository.Interface

        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model {
            try await repository.get(
                newsletterId: newsletterId,
                issueId: issueId
            )
        }

        func edit(
            newsletterId: String,
            issueId: String,
            form: Issue.Form.Input
        ) async throws {
            try await repository.edit(
                newsletterId: newsletterId,
                issueId: issueId,
                form: form
            )
        }
    }
}
