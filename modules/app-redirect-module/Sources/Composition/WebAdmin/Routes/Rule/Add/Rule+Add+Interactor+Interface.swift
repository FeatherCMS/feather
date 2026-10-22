import RedirectApplication
import RedirectModule

extension Rule.Add.Interactor {
    protocol Interface: Sendable {
        func add(
            input: RedirectRuleAddFormInput
        ) async throws
    }
}
