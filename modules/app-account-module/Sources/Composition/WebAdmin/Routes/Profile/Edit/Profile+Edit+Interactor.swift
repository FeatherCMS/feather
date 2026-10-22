import AccountModule
import FeatherWebAdmin
import FeatherWebShared

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
