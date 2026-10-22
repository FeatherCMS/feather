import AccountModule
import AccountDomain

extension Profile.Detail.Repository {

    protocol Interface: Sendable {
        func get() async throws -> Profile.Model
    }
}
