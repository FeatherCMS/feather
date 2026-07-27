struct AdminNewsletterIssueListDefaultInteractor:
    AdminNewsletterIssueListInteractor
{
    let repository: AdminNewsletterIssueListOpenAPIRepository

    func list(newsletterId: String) async throws
        -> [AdminNewsletterIssueListItem]
    {
        try await repository.list(newsletterId: newsletterId)
    }
}
