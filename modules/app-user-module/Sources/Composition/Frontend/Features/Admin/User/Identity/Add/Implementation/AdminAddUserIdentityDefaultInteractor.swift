import FeatherAdmin

struct AdminAddUserIdentityDefaultInteractor: AdminAddUserIdentityInteractor {
    let repository: any AdminAddUserIdentityRepository
    let roleRepository: any AdminUserIdentityRoleRepository

    func loadRoleOptions() async throws -> [UserIdentityRoleOptionModel] {
        try await roleRepository.list()
    }

    func add(
        input: AdminAddUserIdentityFormInput
    ) async throws {
        do {
            try await repository.create(
                payload: .init(
                    name: input.normalizedName,
                    status: input.normalizedStatus,
                    roleIds: input.roleIds ?? []
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized: throw AdminAddUserIdentityError.unauthorized
            case .forbidden: throw AdminAddUserIdentityError.forbidden
            case .conflict: throw AdminAddUserIdentityError.conflict
            default: throw AdminAddUserIdentityError.unavailable
            }
        }
    }
}
