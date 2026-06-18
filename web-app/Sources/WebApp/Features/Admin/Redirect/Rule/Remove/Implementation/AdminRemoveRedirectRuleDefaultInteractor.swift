import Foundation

struct AdminRemoveRedirectRuleDefaultInteractor:
    AdminRemoveRedirectRuleInteractor
{
    let repository: any AdminRemoveRedirectRuleRepository

    func get(
        id: String
    ) async throws -> RedirectRuleDetailsModel {
        try await repository.get(id: id)
    }

    func delete(
        id: String
    ) async throws {
        try await repository.delete(id: id)
    }
}
