import FeatherAdmin

protocol AdminViewRedirectRuleRepository: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel
}
