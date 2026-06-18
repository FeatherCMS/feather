import Hummingbird

protocol AdminRemoveMediaProcessorInteractor: Sendable {

    func getRemoveMediaProcessor(
        id: String
    ) async throws -> AdminRemoveMediaProcessorModel

    func postRemoveMediaProcessor(
        id: String
    ) async throws -> AdminRemoveMediaProcessorModel
}
