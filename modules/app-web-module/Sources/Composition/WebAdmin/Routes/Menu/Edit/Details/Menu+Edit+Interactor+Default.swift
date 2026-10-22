import FeatherWebAdmin
import WebDomain
import OpenAPIRuntime

extension WebDomain.Menu.Edit.Interactor {
    struct Default: Interface {
        let repository: any WebDomain.Menu.Edit.Repository.Interface

        func load(
            id: String
        ) async throws -> MenuDetailsModel {
            try await repository.load(id: id)
        }

        func update(
            id: String,
            input: MenuFormInput
        ) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
