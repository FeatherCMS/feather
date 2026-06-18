import Hummingbird

protocol AdminGetMediaProcessorInteractor: Sendable {

    func getMediaProcessor(
        id: String
    ) async throws -> AdminGetMediaProcessorModel
}
