import Domain

public protocol AccountRepository: Repository {

    func findBy(
        id: String
    ) async throws -> Account?

    func findBy(
        email: String
    ) async throws -> Account?

    func findPasswordHashBy(
        email: String
    ) async throws -> String?

    func findAccountBy(
        sessionToken: String
    ) async throws -> Account?

    func findRolesBy(
        accountId: String
    ) async throws -> [String]

    func findRoleIdsBy(
        accountId: String
    ) async throws -> [String]

    func findPermissionsBy(
        accountId: String
    ) async throws -> [String]

    func insert(
        _ model: Account.New
    ) async throws -> Account

    func update(
        _ model: Account
    ) async throws -> Account

    func replaceRoleIds(
        accountId: String,
        roleIds: [String]
    ) async throws

    func delete(
        id: String
    ) async throws -> Bool

}
