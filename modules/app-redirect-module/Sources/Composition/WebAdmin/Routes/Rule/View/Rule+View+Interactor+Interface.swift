import RedirectApplication
import RedirectModule

extension Rule.View.Interactor {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> RedirectRuleDetailsModel
    }
}
