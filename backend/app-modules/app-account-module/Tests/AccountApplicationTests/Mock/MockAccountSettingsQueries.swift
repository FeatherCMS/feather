import AccountDomain

@testable import AccountApplication

actor MockAccountSettingsQueries: AccountSettingsQueries {
    private(set) var getCallCount = 0
    private let result: AccountSettings

    init(result: AccountSettings) {
        self.result = result
    }

    func get(
        accountID: String
    ) async throws -> AccountSettings {
        getCallCount += 1
        return result
    }
}
