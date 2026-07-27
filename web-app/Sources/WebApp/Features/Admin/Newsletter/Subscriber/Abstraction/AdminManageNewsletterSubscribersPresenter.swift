import Hummingbird

protocol AdminManageNewsletterSubscribersPresenter: Sendable {
    func renderList(
        newsletterId: String,
        items: [AdminManageNewsletterSubscriberItem],
        search: String?,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderForm(
        newsletterId: String,
        email: String,
        firstName: String,
        lastName: String,
        status: String,
        isEdit: Bool,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderRemoveConfirmation(
        newsletterId: String,
        subscriberId: String,
        email: String,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderBulkRemoveConfirmation(
        newsletterId: String,
        search: String?,
        emails: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
