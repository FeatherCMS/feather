import Foundation

struct AdminAddRedirectRuleDefaultInteractor: AdminAddRedirectRuleInteractor {
    let repository: any AdminAddRedirectRuleRepository

    func execute(
        input: RedirectRuleFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
