import WebApplication
import WebDomain
import WebModule

extension MenuItem.Detail.Query {
    struct Mock: Interface {
        let result: MenuItem.Detail.Output

        func find(id: String) async throws -> MenuItem.Detail.Output {
            result
        }
    }
}
