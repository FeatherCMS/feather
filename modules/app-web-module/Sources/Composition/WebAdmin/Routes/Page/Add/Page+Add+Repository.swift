import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Add {
    enum Repository {}
}

extension Page.Add.Repository {
    protocol Interface: Sendable {

        func create(
            input: PageFormInput
        ) async throws
    }
}
