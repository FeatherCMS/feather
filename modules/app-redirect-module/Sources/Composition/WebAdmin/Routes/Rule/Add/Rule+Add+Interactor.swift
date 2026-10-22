import RedirectApplication
import RedirectModule

extension Rule.Add {
    enum Interactor {}
}

extension Rule.Add.Interactor {
    protocol Interface: Sendable {
        func add(
            input: RedirectRuleAddFormInput
        ) async throws
    }
}
