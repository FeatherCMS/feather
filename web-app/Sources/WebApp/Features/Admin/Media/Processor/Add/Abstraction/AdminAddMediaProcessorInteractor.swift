import Hummingbird

protocol AdminAddMediaProcessorInteractor: Sendable {

    func getAddMediaProcessor() async throws
        -> AdminAddMediaProcessorModel

    func postAddMediaProcessor(
        payload: AddProcessorForm
    ) async throws -> AdminAddMediaProcessorModel
}
