import UserDomain

actor MockRoleRepository: RoleRepository {
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var findCallCount = 0
    private(set) var deleteCallCount = 0

    private let result: Role
    private let findResult: Role?
    private let deleteResult: Bool

    init(
        result: Role,
        findResult: Role? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findResult = findResult
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Role? {
        findCallCount += 1
        return findResult
    }

    func insert(
        _ model: Role.New
    ) async throws -> Role {
        createCallCount += 1
        return result
    }

    func update(
        _ model: Role
    ) async throws -> Role {
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
