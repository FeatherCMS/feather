struct AdminListNewsletterIssuesDefaultInteractor:
    AdminListNewsletterIssuesInteractor
{
    let repository: AdminListNewsletterIssuesOpenAPIRepository

    func list(newsletterId: String) async throws
        -> [AdminNewsletterIssueItem]
    {
        try await repository.list(newsletterId: newsletterId)
    }
}
