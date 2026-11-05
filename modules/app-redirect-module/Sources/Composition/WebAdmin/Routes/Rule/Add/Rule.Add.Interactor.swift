import RedirectApplication
import RedirectModule

extension Rule.Add {
    enum Interactor {}
}

extension Rule.Add.Interactor {
    protocol Interface: Sendable {
        func add(
            input: RedirectModule.Rule.Add.Form.Input
        ) async throws
    }
}
