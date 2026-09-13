import FeatherAdmin
import Foundation

struct AdminEditSystemPermissionDefaultInteractor:
    AdminEditSystemPermissionInteractor
{
    let repository: any AdminEditSystemPermissionRepository

    func load(
        id: String
    ) async throws -> SystemPermissionDetailsModel {
        do {
            return try await repository.load(id: id)
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    func update(
        id: String,
        input: SystemPermissionEditFormInput
    ) async throws {
        do {
            try await repository.update(id: id, input: input)
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminEditSystemPermissionError {
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
