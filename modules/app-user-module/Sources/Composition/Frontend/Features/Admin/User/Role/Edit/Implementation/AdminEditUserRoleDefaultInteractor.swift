import FeatherAdmin
import Foundation

struct AdminEditUserRoleDefaultInteractor: AdminEditUserRoleInteractor {
    let repository: any AdminEditUserRoleRepository

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel {
        do { return try await repository.load(id: id) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func edit(
        id: String,
        input: AdminEditUserRoleFormInput
    ) async throws {
        do {
            try await repository.update(
                id: id,
                payload: .init(
                    name: input.normalizedName,
                    notes: input.normalizedNotes
                )
            )
        }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    private func map(_ error: OpenAPIRepositoryError) -> AdminEditUserRoleError
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
