import Hummingbird

protocol AdminEditMediaProcessorInteractor: Sendable {

    func getEditMediaProcessor(
        id: String
    ) async throws -> AdminEditMediaProcessorModel

    func postEditMediaProcessor(
        id: String,
        payload: AddProcessorForm
    ) async throws -> AdminEditMediaProcessorModel
}
