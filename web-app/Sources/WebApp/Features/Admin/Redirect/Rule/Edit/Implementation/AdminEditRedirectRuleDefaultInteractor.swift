import Foundation

struct AdminEditRedirectRuleDefaultInteractor:
    AdminEditRedirectRuleInteractor
{
    let repository: any AdminEditRedirectRuleRepository

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: RedirectRuleFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
