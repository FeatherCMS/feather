import FeatherWebAdmin
import FeatherWebShared
import UserModule

extension Identity.Edit.Interactor {
    struct Default: Interface {
        let identityRepository: any Identity.Edit.Repository.Interface
        let roleRepository: any Identity.Edit.Repository.Role.Interface

        func load(
            id: String
        ) async throws -> Identity.Edit.Model {
            do { return try await identityRepository.load(id: id) }
            catch let error as OpenAPIRepositoryError { throw map(error) }
        }

        func loadRoleOptions() async throws
            -> [Identity.Edit.RoleOption]
        {
            do { return try await roleRepository.list() }
            catch let error as OpenAPIRepositoryError { throw map(error) }
        }

        func edit(
            id: String,
            input: Identity.Edit.Form.Input
        ) async throws {
            do {
                try await identityRepository.update(
                    id: id,
                    payload: .init(
                        name: input.normalizedName,
                        status: input.normalizedStatus,
                        roleIds: input.roleIds
                    )
                )
            }
            catch let error as OpenAPIRepositoryError { throw map(error) }
        }

        private func map(_ error: OpenAPIRepositoryError)
            -> Identity.Edit.Error
        {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .conflict: .conflict
            default: .unavailable
            }
        }
    }
}
