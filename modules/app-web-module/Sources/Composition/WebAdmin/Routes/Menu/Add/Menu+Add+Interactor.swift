import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Add {
    enum Interactor {}
}

extension Menu.Add.Interactor {
    protocol Interface: Sendable {

        func execute(
            input: MenuFormInput
        ) async throws
    }
}
