import Foundation

struct AdminEditUserAccountDefaultInteractor: AdminEditUserAccountInteractor {
    let accountRepository: any AdminEditUserAccountRepository
    let roleRepository: any AdminEditUserAccountRoleRepository

    func loadAccount(
        id: String
    ) async throws -> AdminEditUserAccountModel {
        try await accountRepository.get(id: id)
    }

    func loadRoleOptions() async throws -> [AdminEditUserAccountRoleOptionModel]
    {
        try await roleRepository.list()
    }

    func update(
        entity: AdminEditUserAccountModel
    ) async throws {
        try await accountRepository.update(
            id: entity.id,
            payload: entity.payload
        )
    }
}
