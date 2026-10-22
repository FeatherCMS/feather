import AccountModule

extension Profile.Edit.Repository {

    protocol Interface: Sendable {
        func get() async throws -> Profile.Model

        func update(
            profile: Profile.Model
        ) async throws
    }
}
