import Hummingbird

protocol AdminListNewsletterIssuesPresenter: Sendable {
    func render(
        newsletterId: String,
        items: [AdminNewsletterIssueItem],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
