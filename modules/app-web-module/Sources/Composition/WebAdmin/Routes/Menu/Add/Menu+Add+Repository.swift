import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Add {
    enum Repository {}
}

extension WebModule.Menu.Add.Repository {
    protocol Interface: Sendable {

        func create(
            input: MenuFormInput
        ) async throws
    }
}
