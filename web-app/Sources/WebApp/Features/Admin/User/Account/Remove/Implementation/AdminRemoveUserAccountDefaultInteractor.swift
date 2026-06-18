import Foundation

struct AdminRemoveUserAccountDefaultInteractor: AdminRemoveUserAccountInteractor
{
    private let repository: any AdminRemoveUserAccountRepository

    init(repository: any AdminRemoveUserAccountRepository) {
        self.repository = repository
    }

    func execute(
        entity: AdminRemoveUserAccountModel
    ) async throws {
        try await repository.delete(id: entity.id)
    }
}
