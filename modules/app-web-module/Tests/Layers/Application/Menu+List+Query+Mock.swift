import WebApplication
import WebDomain

extension Menu.List.Query {
    struct Mock: Interface {
        let result: Menu.List.Output

        func list() async throws -> Menu.List.Output {
            result
        }
    }
}
