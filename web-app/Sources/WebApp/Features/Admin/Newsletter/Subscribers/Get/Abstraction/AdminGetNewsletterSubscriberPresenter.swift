import Hummingbird

protocol AdminGetNewsletterSubscriberPresenter: Sendable {
    func render(
        model: AdminGetNewsletterSubscriberModel,
        permissions: Set<String>
    ) -> HTMLResponse
    func render(
        subscriberId: String,
        newsletterId: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
