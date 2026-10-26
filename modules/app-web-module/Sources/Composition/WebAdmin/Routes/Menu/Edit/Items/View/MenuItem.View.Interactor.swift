import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.View {
    enum Interactor {}
}

extension MenuItem.View.Interactor {
    protocol Interface: Sendable {
        func execute(input: MenuItem.View.Input) async throws
            -> MenuItem.View.Model
    }
}
