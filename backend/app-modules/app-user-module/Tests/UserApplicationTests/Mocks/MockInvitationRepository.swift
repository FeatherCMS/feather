import UserDomain

actor MockInvitationRepository: InvitationRepository {
    private(set) var createCallCount = 0
    private(set) var deleteCallCount = 0

    private let result: Invitation
    private let deleteResult: Bool

    init(
        result: Invitation,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Invitation? {
        nil
    }

    func insert(
        _ model: Invitation.New
    ) async throws -> Invitation {
        createCallCount += 1
        return result
    }

    func update(
        _ model: Invitation
    ) async throws -> Invitation {
        model
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        return deleteResult
    }
}
