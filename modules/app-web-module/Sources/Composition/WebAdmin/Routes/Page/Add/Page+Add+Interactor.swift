import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Add {
    enum Interactor {}
}

extension Page.Add.Interactor {
    protocol Interface: Sendable {

        func execute(
            input: PageFormInput
        ) async throws
    }
}
