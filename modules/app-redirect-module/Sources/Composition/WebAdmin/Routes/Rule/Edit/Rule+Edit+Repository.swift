import RedirectApplication
import RedirectModule

extension Rule.Edit {
    enum Repository {}
}

extension Rule.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> RedirectRuleEditModel

        func update(
            id: String,
            input: RedirectRuleEditFormInput
        ) async throws
    }
}
