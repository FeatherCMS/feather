import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Edit {
    enum Repository {}
}

extension Menu.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> MenuDetailsModel

        func update(
            id: String,
            input: MenuFormInput
        ) async throws
    }
}
