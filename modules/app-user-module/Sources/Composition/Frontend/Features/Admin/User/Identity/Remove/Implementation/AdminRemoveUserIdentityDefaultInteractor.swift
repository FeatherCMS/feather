import FeatherAdmin
import Foundation

struct AdminRemoveUserIdentityDefaultInteractor:
    AdminRemoveUserIdentityInteractor
{
    private let repository: any AdminRemoveUserIdentityRepository

    init(repository: any AdminRemoveUserIdentityRepository) {
        self.repository = repository
    }

    func execute(
        entity: AdminRemoveUserIdentityModel
    ) async throws {
        try await repository.delete(id: entity.id)
    }
}
