import Hummingbird

protocol AdminNewsletterIssueListPresenter: Sendable {
    func render(
        newsletterId: String,
        items: [AdminNewsletterIssueListItem],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
