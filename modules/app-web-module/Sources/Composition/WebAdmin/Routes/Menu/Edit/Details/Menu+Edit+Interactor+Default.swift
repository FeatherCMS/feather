import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Edit.Interactor {
    struct Default: Interface {
        let repository: any Menu.Edit.Repository.Interface

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
