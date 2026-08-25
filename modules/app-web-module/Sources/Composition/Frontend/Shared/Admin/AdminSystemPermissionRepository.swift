protocol AdminSystemPermissionRepository: Sendable {

    func listNames(
        // empty
    ) async throws -> [String]
}
