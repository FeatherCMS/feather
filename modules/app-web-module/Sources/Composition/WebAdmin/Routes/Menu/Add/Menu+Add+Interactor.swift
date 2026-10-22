import FeatherWebAdmin
import WebDomain
import OpenAPIRuntime

extension WebDomain.Menu.Add {
    enum Interactor {}
}

extension WebDomain.Menu.Add.Interactor {
    protocol Interface: Sendable {

        func execute(
            input: MenuFormInput
        ) async throws
    }
}
