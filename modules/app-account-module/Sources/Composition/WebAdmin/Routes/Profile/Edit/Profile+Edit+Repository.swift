import AccountModule

extension Profile.Edit.Repository {

    protocol Interface: Sendable {
        func get() async throws -> AdminAccountProfileModel

        func update(
            profile: AdminAccountProfileModel
        ) async throws
    }
}
