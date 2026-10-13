protocol AdminAddRedirectRuleInteractor: Sendable {

    func add(
        input: RedirectRuleAddFormInput
    ) async throws
}
