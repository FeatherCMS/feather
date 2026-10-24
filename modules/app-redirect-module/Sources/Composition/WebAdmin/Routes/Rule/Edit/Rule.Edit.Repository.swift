import RedirectApplication
import RedirectModule

extension Rule.Edit {
    enum Repository {}
}

extension Rule.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Rule.Edit.Model

        func update(
            id: String,
            input: RedirectModule.Rule.Edit.Form.Input
        ) async throws
    }
}
