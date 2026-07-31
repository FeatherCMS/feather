import AccountDomain

actor MockAccountSettingsRepository: AccountSettingsRepository {
    private(set) var updateCallCount = 0
    private(set) var updatedModel: AccountSettings?
    private let result: AccountSettings

    init(result: AccountSettings) {
        self.result = result
    }

    func create(
        accountID: String
    ) async throws {}

    func update(
        _ model: AccountSettings
    ) async throws -> AccountSettings {
        updateCallCount += 1
        updatedModel = model
        return model
    }

    func delete(
        id: String
    ) async throws {}
}
