import AccountModule

extension Profile.Detail.Repository {

    protocol Interface: Sendable {
        func get() async throws -> AdminAccountProfileModel
    }
}
