import WebModule

extension MenuItem.Permission {
    enum Repository {}
}

extension MenuItem.Permission.Repository {
    protocol Interface: Sendable {

        func listNames(  // empty
            ) async throws -> [String]
    }
}
