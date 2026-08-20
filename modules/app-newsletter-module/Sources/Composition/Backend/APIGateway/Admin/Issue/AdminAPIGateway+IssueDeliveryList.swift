import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterIssueDeliveryList(
        _ input: Operations.NewsletterIssueDeliveryList.Input
    ) async throws -> Operations.NewsletterIssueDeliveryList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeListNewsletterDeliveries()
            .execute(
                subject: subject,
                input: .init(issueId: input.path.newsletterIssueId)
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
