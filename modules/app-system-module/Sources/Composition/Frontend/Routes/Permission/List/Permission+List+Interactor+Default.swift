import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.List.Interactor {
    struct Default:
        WebAdmin.System.Permission.List.Interactor.Interface
    {
        let repository: any WebAdmin.System.Permission.List.Repository.Interface

        func listSystemPermissions(
            page: Int,
            search: String?
        ) async throws -> WebAdmin.System.Permission.List.Model {
            do {
                return try await repository.listSystemPermissions(
                    page: page,
                    search: search
                )
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized:
                    throw WebAdmin.System.Permission.List.Error.unauthorized
                case .forbidden:
                    throw WebAdmin.System.Permission.List.Error.forbidden
                case .failure, .transport, .notFound, .conflict:
                    throw WebAdmin.System.Permission.List.Error.unavailable
                }
            }
        }

    }
}
