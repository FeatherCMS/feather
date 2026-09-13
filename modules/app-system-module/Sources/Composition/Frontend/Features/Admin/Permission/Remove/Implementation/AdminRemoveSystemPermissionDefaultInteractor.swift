import FeatherAdmin
import Foundation

struct AdminRemoveSystemPermissionDefaultInteractor:
    AdminRemoveSystemPermissionInteractor
{
    let repository: any AdminRemoveSystemPermissionRepository

    func names(ids: [String]) async throws -> [String] {
        do {
            var result: [String] = []
            for id in ids {
                result.append(try await repository.get(id: id).name ?? "")
            }
            return result
        } catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    func delete(ids: [String]) async throws {
        do {
            for id in ids {
                try await repository.delete(id: id)
            }
        } catch let error as OpenAPIRepositoryError {
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
