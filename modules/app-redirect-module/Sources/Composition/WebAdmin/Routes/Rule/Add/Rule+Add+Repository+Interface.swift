import RedirectApplication
import RedirectModule

extension Rule.Add.Repository {
    protocol Interface: Sendable {
        func create(
            input: RedirectRuleAddFormInput
        ) async throws
    }
}
