import UserDomain

actor MockAccountRepository: AccountRepository {
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var findByIdCallCount = 0
    private(set) var deleteCallCount = 0

    private let result: Account
    private let findByIdResult: Account?
    private let deleteResult: Bool

    init(
        result: Account,
        findByIdResult: Account? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findByIdResult = findByIdResult
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Account? {
        findByIdCallCount += 1
        return findByIdResult
    }

    func findBy(
        email: String
    ) async throws -> Account? {
        nil
    }

    func findPasswordHashBy(
        email: String
    ) async throws -> String? {
        nil
    }

    func findAccountBy(
        sessionToken: String
    ) async throws -> Account? {
        nil
    }

    func findRolesBy(
        accountId: String
    ) async throws -> [String] {
        []
    }

    func findPermissionsBy(
        accountId: String
    ) async throws -> [String] {
        []
    }

    func insert(
        _ model: Account.New
    ) async throws -> Account {
        createCallCount += 1
        return result
    }

    func update(
        _ model: Account
    ) async throws -> Account {
        updateCallCount += 1
        return model
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        return deleteResult
    }
}
