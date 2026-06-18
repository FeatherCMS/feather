import Foundation

struct AdminGetUserAccountDefaultInteractor: AdminGetUserAccountInteractor {
    private let repository: any AdminGetUserAccountRepository

    init(repository: any AdminGetUserAccountRepository) {
        self.repository = repository
    }

    func execute(
        id: String
    ) async throws -> AdminGetUserAccountModel {
        let details = try await repository.get(id: id)
        let sessions = (try? await repository.getSessions(id: id)) ?? []
        return .init(details: details, sessions: sessions)
    }
}
