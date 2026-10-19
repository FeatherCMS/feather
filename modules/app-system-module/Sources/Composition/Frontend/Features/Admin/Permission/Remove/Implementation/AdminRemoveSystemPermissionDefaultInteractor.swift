import SystemModule
import FeatherAdmin

struct AdminRemoveSystemPermissionDefaultInteractor:
    AdminRemoveSystemPermissionInteractor
{
    let repository: any AdminRemoveSystemPermissionRepository

    func delete(ids: [String]) async throws {
        do {
            for id in ids {
                try await repository.delete(id: id)
            }
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminRemoveSystemPermissionError {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        case .failure(let failure) where failure.statusCode == 409: .conflict
        case .failure, .transport: .unavailable
        }
    }
}
