import AccountDomain

@testable import AccountApplication

actor MockSettingsQueries: SettingsQueries {
    private(set) var getCallCount = 0
    private let result: Settings

    init(result: Settings) {
        self.result = result
    }

    func get(
        userId: String
    ) async throws -> Settings {
        getCallCount += 1
        return result
    }
}
