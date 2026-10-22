import RedirectApplication
import RedirectModule

extension Rule.View.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> RedirectRuleDetailsModel
    }
}
