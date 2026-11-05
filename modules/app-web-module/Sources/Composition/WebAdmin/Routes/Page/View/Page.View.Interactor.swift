import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.View {
    enum Interactor {}
}

extension Page.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: Page.View.Input
        ) async throws -> Page.Details.Model
    }
}
