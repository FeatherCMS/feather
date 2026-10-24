import WebApplication
import WebDomain
import WebModule

extension Menu.List.Query {
    struct Mock: Interface {
        let result: Menu.List.Output

        func list() async throws -> Menu.List.Output {
            result
        }
    }
}
