import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Add {
    enum Interactor {}
}

extension WebModule.Menu.Add.Interactor {
    protocol Interface: Sendable {

        func execute(
            input: MenuFormInput
        ) async throws
    }
}
