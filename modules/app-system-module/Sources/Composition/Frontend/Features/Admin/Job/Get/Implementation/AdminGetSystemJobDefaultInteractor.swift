import FeatherAdmin

struct AdminGetSystemJobDefaultInteractor: AdminGetSystemJobInteractor {
    let repository: any AdminGetSystemJobRepository

    func execute(entity: AdminGetSystemJobModel) async throws
        -> SystemJobDetailsModel {
        do {
            return try await repository.get(id: entity.id)
        } catch let error as OpenAPIRepositoryError {
            switch error {
            case .notFound: throw AdminGetSystemJobError.notFound
            case .unauthorized: throw AdminGetSystemJobError.unauthorized
            case .forbidden: throw AdminGetSystemJobError.forbidden
            case .failure, .transport, .conflict:
                throw AdminGetSystemJobError.unavailable
            }
        }
    }
}
