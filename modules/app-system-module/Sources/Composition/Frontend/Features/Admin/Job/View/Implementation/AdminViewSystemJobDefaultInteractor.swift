import FeatherAdmin

struct AdminViewSystemJobDefaultInteractor: AdminViewSystemJobInteractor {
    let repository: any AdminViewSystemJobRepository

    func execute(entity: AdminViewSystemJobModel) async throws
        -> SystemJobDetailsModel
    {
        do {
            return try await repository.get(id: entity.id)
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .notFound: throw AdminViewSystemJobError.notFound
            case .unauthorized: throw AdminViewSystemJobError.unauthorized
            case .forbidden: throw AdminViewSystemJobError.forbidden
            case .failure, .transport, .conflict:
                throw AdminViewSystemJobError.unavailable
            }
        }
    }
}
