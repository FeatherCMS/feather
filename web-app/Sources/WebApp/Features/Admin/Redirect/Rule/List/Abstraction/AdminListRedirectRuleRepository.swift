import Hummingbird

protocol AdminListRedirectRuleRepository: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: Int?
    ) async throws -> AdminListRedirectRuleModel

    func delete(
        id: String
    ) async throws
}
