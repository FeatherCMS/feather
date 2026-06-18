import UserDomain

public protocol RoleQueries: Sendable {

    func list(
        query: RoleList.Query
    ) async throws -> RoleList

    func count(
        query: RoleList.Query
    ) async throws -> Int

    func getBy(
        id: String
    ) async throws -> RoleDetail
}
