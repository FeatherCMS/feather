import FeatherWebAdmin
import WebDomain
import OpenAPIRuntime

extension WebDomain.Menu.View {
    enum Interactor {}
}

extension WebDomain.Menu.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            input: WebDomain.Menu.View.Input
        ) async throws -> MenuDetailsModel
    }
}
