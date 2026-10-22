import UserModule

extension Identity.Edit.Interactor {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Identity.Edit.Model

        func loadRoleOptions() async throws
            -> [Identity.Edit.RoleOption]

        func edit(
            id: String,
            input: Identity.Edit.FormInput
        ) async throws
    }
}
