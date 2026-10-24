import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Add {
    enum Repository {}
}

extension Page.Add.Repository {
    protocol Interface: Sendable {

        func create(
            input: Page.Form.Input
        ) async throws
    }
}
