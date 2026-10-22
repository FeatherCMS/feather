import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Add {
    enum Repository {}
}

extension Menu.Add.Repository {
    protocol Interface: Sendable {

        func create(
            input: MenuFormInput
        ) async throws
    }
}
