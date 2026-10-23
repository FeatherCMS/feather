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
        func get() async throws -> Profile.WebAdminModel

        func update(
            profile: Profile.WebAdminModel
        ) async throws
    }
}
