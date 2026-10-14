import FeatherAdmin

struct AdminRemoveUserIdentityDefaultInteractor:
    AdminRemoveUserIdentityInteractor
{
    private let repository: any AdminRemoveUserIdentityRepository

    init(repository: any AdminRemoveUserIdentityRepository) {
        self.repository = repository
    }


    func delete(
        ids: [String]
    ) async throws {
        do { try await repository.delete(ids: ids) }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(_ error: OpenAPIRepositoryError)
        -> AdminRemoveUserIdentityError
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
