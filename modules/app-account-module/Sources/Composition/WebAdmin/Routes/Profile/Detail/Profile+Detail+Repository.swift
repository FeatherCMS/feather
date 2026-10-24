import AccountDomain
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Detail {
    enum Repository {}
}

extension Profile.Detail.Repository {

    protocol Interface: Sendable {
        func get() async throws -> Profile.Remote.Model
    }
}
