import AccountDomain
import AccountModule

@testable import AccountApplication

actor MockAccountProfileRepository: Profile.Repository.Interface,
    Profile.Detail.Query.Interface
{
    private(set) var findCallCount = 0
    private(set) var getOrCreateCallCount = 0
    private(set) var requestedUserIds: [String] = []
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var updatedModel: Profile.Model?

    private let result: Profile.Model

    init(result: Profile.Model) {
        self.result = result
    }

    func get(userId: String) async throws -> Profile.Model {
        requestedUserIds.append(userId)
        return result
    }

    func find(userId: String) async throws -> Profile.Detail.Output {
        findCallCount += 1
        requestedUserIds.append(userId)
        return .init(
            userId: result.userId,
            firstName: result.firstName,
            lastName: result.lastName,
            profileImageAssetId: result.profileImageAssetId,
            createdAt: result.createdAt,
            updatedAt: result.updatedAt
        )
    }

    func getOrCreate(userId: String) async throws -> Profile.Model {
        getOrCreateCallCount += 1
        requestedUserIds.append(userId)
        return result
    }

    func create(userId: String) async throws {
        createCallCount += 1
    }

    func update(_ model: Profile.Model) async throws
        -> Profile.Model
    {
        updateCallCount += 1
        updatedModel = model
        return model
    }

    func delete(userId: String) async throws {}
}
