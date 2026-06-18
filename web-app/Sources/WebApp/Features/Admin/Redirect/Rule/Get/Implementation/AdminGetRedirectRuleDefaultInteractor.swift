import Foundation

struct AdminGetRedirectRuleDefaultInteractor: AdminGetRedirectRuleInteractor {
    let repository: any AdminGetRedirectRuleRepository

    func execute(
        entity: AdminGetRedirectRuleModel
    ) async throws -> RedirectRuleDetailsModel {
        try await repository.get(id: entity.id)
    }
}
