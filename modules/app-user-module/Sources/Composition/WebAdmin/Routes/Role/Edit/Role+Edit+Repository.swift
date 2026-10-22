import FeatherWebAdmin
import UserModule



extension Role.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Role.Detail.RepositoryModel

        func update(
            id: String,
            payload: Role.Edit.FormPayload
        ) async throws
    }
}
