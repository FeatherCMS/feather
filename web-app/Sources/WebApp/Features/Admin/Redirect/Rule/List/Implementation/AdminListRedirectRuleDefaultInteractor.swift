import Hummingbird

struct AdminListRedirectRuleDefaultInteractor:
    AdminListRedirectRuleInteractor
{
    let repository: any AdminListRedirectRuleRepository

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: Int?
    ) async throws -> AdminListRedirectRuleModel {
        try await repository.listRedirectRules(
            page: page,
            search: search,
            statusCode: statusCode
        )
    }

    func bulkRemove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
