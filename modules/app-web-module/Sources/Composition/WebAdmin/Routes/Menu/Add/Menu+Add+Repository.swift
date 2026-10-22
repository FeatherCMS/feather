import FeatherWebAdmin
import WebDomain
import OpenAPIRuntime

extension WebDomain.Menu.Add {
    enum Repository {}
}

extension WebDomain.Menu.Add.Repository {
    protocol Interface: Sendable {

        func create(
            input: MenuFormInput
        ) async throws
    }
}
