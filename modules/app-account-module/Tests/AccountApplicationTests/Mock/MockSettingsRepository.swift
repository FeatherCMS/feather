import AccountDomain

actor MockSettingsRepository: SettingsRepository {
    private(set) var getCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var updatedModel: Settings?
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

    func getOrCreate(
        userId: String
    ) async throws -> Settings {
        getCallCount += 1
        return result
    }

    func create(
        userId: String
    ) async throws {}

    func update(
        _ model: Settings
    ) async throws -> Settings {
        updateCallCount += 1
        updatedModel = model
        return model
    }

    func delete(
        userId: String
    ) async throws {}
}
