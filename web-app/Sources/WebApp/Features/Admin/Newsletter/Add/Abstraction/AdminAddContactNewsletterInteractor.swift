protocol AdminAddContactNewsletterInteractor: Sendable {
    func getAddContactNewsletter() async throws
        -> AdminAddContactNewsletterModel
    func postAddContactNewsletter(payload: ContactNewsletterAddForm)
        async throws -> AdminAddContactNewsletterModel
}
