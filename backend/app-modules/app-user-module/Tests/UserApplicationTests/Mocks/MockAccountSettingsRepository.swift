import AccountDomain

actor MockAccountSettingsRepository: AccountSettingsRepository {
    private(set) var createCallCount = 0

    func create(
        accountID: String
    ) async throws {
        createCallCount += 1
    }

    func update(
        _ model: AccountSettings
    ) async throws -> AccountSettings {
        fatalError("not needed in tests")
    }

    func delete(
        id: String
    ) async throws {
        fatalError("not needed in tests")
    }
}
