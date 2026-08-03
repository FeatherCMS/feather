import Hummingbird

protocol AdminEditNewsletterSubscriberPresenter: Sendable {
    func render(
        model: AdminGetNewsletterSubscriberModel,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
