import Hummingbird

struct AdminRemoveMediaProcessorDefaultInteractor:
    AdminRemoveMediaProcessorInteractor
{
    let repository: AdminMediaProcessorOpenAPIRepository

    func getRemoveMediaProcessor(
        id: String
    ) async throws -> AdminRemoveMediaProcessorModel {
        .init(id: id, error: nil)
    }

    func postRemoveMediaProcessor(
        id: String
    ) async throws -> AdminRemoveMediaProcessorModel {
        do {
            try await repository.deleteProcessor(id: id)
        }
        catch let error as OpenAPIRepositoryError {
            return .init(id: id, error: error.errorDescription)
        }
        return .init(id: id, error: nil)
    }
}
