import Hummingbird

struct AdminGetMediaProcessorDefaultInteractor: AdminGetMediaProcessorInteractor
{
    let repository: AdminMediaProcessorOpenAPIRepository

    func getMediaProcessor(
        id: String
    ) async throws -> AdminGetMediaProcessorModel {
        .init(item: try await repository.getProcessor(id: id))
    }
}
