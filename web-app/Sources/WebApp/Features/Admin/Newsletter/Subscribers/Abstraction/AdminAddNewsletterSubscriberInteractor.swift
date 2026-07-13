protocol AdminAddNewsletterSubscriberInteractor: Sendable {
    func get() async throws -> AdminAddNewsletterSubscriberModel
    func post(form: AdminAddNewsletterSubscriberForm) async throws -> AdminAddNewsletterSubscriberModel
}
