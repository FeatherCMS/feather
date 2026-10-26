import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Edit {
    enum Interactor {}
}

extension Profile.Edit.Interactor {

    protocol Interface: Sendable {

        func loadProfile(
            account: AccountModel
        ) async throws -> Profile.Edit.Model

        func execute(
            entity: Profile.Edit.Model
        ) async throws
    }
}
