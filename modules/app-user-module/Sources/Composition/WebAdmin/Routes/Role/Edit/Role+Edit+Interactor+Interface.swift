import FeatherWebAdmin
import UserModule

extension Role.Edit.Interactor {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Role.Detail.RepositoryModel

        func edit(
            id: String,
            input: Role.Edit.FormInput
        ) async throws
    }
}
