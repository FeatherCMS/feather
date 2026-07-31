import Hummingbird

protocol AdminListNewsletterSubscribersPresenter: Sendable {
    func render(
        model: AdminNewsletterSubscribersListModel,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
