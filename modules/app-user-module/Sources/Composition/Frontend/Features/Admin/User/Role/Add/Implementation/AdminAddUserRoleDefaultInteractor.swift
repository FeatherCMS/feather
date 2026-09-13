import FeatherAdmin
import Foundation

struct AdminAddUserRoleDefaultInteractor: AdminAddUserRoleInteractor {
    let repository: any AdminAddUserRoleRepository

    func add(
        input: AdminAddUserRoleFormInput
    ) async throws {
        do {
            try await repository.create(
                payload: .init(
                    name: input.normalizedName,
                    notes: input.normalizedNotes
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized: throw AdminAddUserRoleError.unauthorized
            case .forbidden: throw AdminAddUserRoleError.forbidden
            case .conflict: throw AdminAddUserRoleError.conflict
            default: throw AdminAddUserRoleError.unavailable
            }
        }
    }
}
