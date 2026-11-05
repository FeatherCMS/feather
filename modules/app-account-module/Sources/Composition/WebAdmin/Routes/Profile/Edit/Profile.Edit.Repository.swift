import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Edit {
    enum Repository {}
}

extension Profile.Edit.Repository {

    protocol Interface: Sendable {
        func get() async throws -> Profile.Remote.Model

        func update(
            profile: Profile.Remote.Model
        ) async throws
    }
}
