import Hummingbird

protocol AdminListRedirectRuleInteractor: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: Int?
    ) async throws -> AdminListRedirectRuleModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
