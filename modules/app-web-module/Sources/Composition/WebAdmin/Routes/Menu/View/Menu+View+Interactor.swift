import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.View {
    enum Interactor {}
}

extension Menu.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            input: Menu.View.Input
        ) async throws -> MenuDetailsModel
    }
}
