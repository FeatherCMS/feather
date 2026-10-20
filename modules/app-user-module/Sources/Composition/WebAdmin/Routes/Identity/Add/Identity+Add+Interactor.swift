import UserModule

extension Identity.Add {
    enum Interactor {}
}

extension Identity.Add.Interactor {
    protocol Interface: Sendable {

        func loadRoleOptions() async throws -> [Identity.Add.RoleOption]

        func add(
            input: Identity.Add.FormInput
        ) async throws
    }
}
