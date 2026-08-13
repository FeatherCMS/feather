import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension NewsletterBackend {
    public func newsletterIssueGet(
        _ input: Operations.NewsletterIssueGet.Input
    ) async throws -> Operations.NewsletterIssueGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.makeGetNewsletterIssue()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsletterIssueId)
            )
        return .ok(.init(body: .json(map(result))))
    }
}
