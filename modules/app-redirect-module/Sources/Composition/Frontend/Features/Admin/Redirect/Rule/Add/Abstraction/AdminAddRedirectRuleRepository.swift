import FeatherAdmin

protocol AdminAddRedirectRuleRepository: Sendable {

    func create(
        input: RedirectRuleAddFormInput
    ) async throws
}
