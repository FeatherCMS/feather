import FeatherAdmin
import Hummingbird

struct AdminAddSystemPermissionDefaultInteractor:
    AdminAddSystemPermissionInteractor
{
    let repository: any AdminAddSystemPermissionRepository

    func execute(
        entity: AdminAddSystemPermissionModel
    ) async throws {
        do {
            try await repository.create(entity: entity)
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminAddSystemPermissionError {
        switch error {
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .conflict:
            .conflict
        case .failure(let failure) where failure.statusCode == 409:
            .conflict
        case .failure, .transport, .notFound:
            .unavailable
        }
    }
}
