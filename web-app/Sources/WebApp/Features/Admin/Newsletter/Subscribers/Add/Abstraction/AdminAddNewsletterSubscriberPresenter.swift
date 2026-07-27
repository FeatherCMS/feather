import Hummingbird

protocol AdminAddNewsletterSubscriberPresenter: Sendable {
    func render(
        model: AdminAddNewsletterSubscriberModel,
        isAdded: Bool,
        permissions: Set<String>
    ) -> HTMLResponse
}
