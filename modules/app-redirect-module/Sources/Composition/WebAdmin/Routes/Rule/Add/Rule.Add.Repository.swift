import RedirectApplication
import RedirectModule

extension Rule.Add {
    enum Repository {}
}

extension Rule.Add.Repository {
    protocol Interface: Sendable {
        func create(
            input: RedirectModule.Rule.Add.Form.Input
        ) async throws
    }
}
