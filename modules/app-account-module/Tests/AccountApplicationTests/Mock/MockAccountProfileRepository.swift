import AccountDomain

@testable import AccountApplication

actor MockAccountProfileRepository: AccountProfileRepository, AccountProfileQueries {
    private(set) var getCallCount = 0
    private(set) var getOrCreateCallCount = 0
    private(set) var requestedUserIds: [String] = []
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var updatedModel: AccountProfile?

    private let result: AccountProfile

    init(result: AccountProfile) {
        self.result = result
    }

    func get(userId: String) async throws -> AccountProfile {
        getCallCount += 1
        requestedUserIds.append(userId)
        return result
    }

    func getOrCreate(userId: String) async throws -> AccountProfile {
        getOrCreateCallCount += 1
        requestedUserIds.append(userId)
        return result
    }

    func create(userId: String) async throws {
        createCallCount += 1
    }

    func update(_ model: AccountProfile) async throws -> AccountProfile {
        updateCallCount += 1
        updatedModel = model
        return model
    }

    func delete(userId: String) async throws {}
}
