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
            input: WebModule.Menu.Form.Input
        ) async throws
    }
}
