import FeatherWebAdmin
import FeatherWebShared
import UserModule

extension Identity.Add.Interactor {
    struct Default: Interface {
        let repository: any Identity.Add.Repository.Interface
        let roleRepository: any Identity.Add.Repository.Role.Interface

        func loadRoleOptions() async throws -> [Identity.Add.RoleOption] {
            try await roleRepository.list()
        }

        func add(
            input: Identity.Add.FormInput
        ) async throws {
            do {
                try await repository.create(
                    payload: .init(
                        name: input.normalizedName,
                        status: input.normalizedStatus,
                        roleIds: input.roleIds
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized: throw Identity.Add.Error.unauthorized
                case .forbidden: throw Identity.Add.Error.forbidden
                case .conflict: throw Identity.Add.Error.conflict
                default: throw Identity.Add.Error.unavailable
                }
            }
        }
    }
}
