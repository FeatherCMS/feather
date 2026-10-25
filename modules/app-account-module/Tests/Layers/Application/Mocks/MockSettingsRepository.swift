import AccountDomain
import AccountModule

@testable import AccountApplication

actor MockSettingsRepository: Settings.Repository.Interface,
    Settings.Detail.Query.Interface
{
    private(set) var getCallCount = 0
    private(set) var findCallCount = 0
    private(set) var getOrCreateCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var updatedModel: Settings.Model?
    private let result: Settings.Model

    init(result: Settings.Model) {
        self.result = result
    }

    func get(
        userId: String
    ) async throws -> Settings.Model {
        getCallCount += 1
        return result
    }

    func find(
        userId: String
    ) async throws -> Settings.Detail.Output {
        findCallCount += 1
        return .init(
            userId: result.userId,
            language: result.language,
            timezone: result.timezone,
            pageSize: result.pageSize,
            createdAt: result.createdAt,
            updatedAt: result.updatedAt
        )
    }

    func getOrCreate(
        userId: String
    ) async throws -> Settings.Model {
        getOrCreateCallCount += 1
        return result
    }

    func create(
        userId: String
    ) async throws {}

    func update(
        _ model: Settings.Model
    ) async throws -> Settings.Model {
        updateCallCount += 1
        updatedModel = model
        return model
    }

    func delete(
        userId: String
    ) async throws {}
}
