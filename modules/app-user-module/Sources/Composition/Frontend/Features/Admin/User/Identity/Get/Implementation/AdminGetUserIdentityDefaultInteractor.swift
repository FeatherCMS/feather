import FeatherAdmin
import Foundation

struct AdminGetUserIdentityDefaultInteractor: AdminGetUserIdentityInteractor {
    private let repository: any AdminGetUserIdentityRepository

    init(repository: any AdminGetUserIdentityRepository) {
        self.repository = repository
    }

    func execute(
        id: String
    ) async throws -> AdminGetUserIdentityModel {
        let details = try await repository.get(id: id)
        return .init(details: details)
    }
}
