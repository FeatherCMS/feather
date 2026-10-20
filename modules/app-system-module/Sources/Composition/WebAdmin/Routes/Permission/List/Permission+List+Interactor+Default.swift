import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.List.Interactor {
    struct Default:
        Interface
    {
        let repository:
            any Permission.List.Repository
                .Interface

        func listSystemPermissions(
            page: Int,
            search: String?
        ) async throws -> Permission.List.Model {
            do {
                return try await repository.listSystemPermissions(
                    page: page,
                    search: search
                )
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized:
                    throw Permission.List.Error
                        .unauthorized
                case .forbidden:
                    throw Permission.List.Error
                        .forbidden
                case .failure, .transport, .notFound, .conflict:
                    throw Permission.List.Error
                        .unavailable
                }
            }
        }

    }
}
