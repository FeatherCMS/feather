import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.View {
    enum Interactor {}
}

extension WebModule.Menu.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            input: WebModule.Menu.View.Input
        ) async throws -> WebModule.Menu.View.Model
    }
}
