import Hummingbird

struct AdminAddMediaProcessorDefaultInteractor:
    AdminAddMediaProcessorInteractor
{
    let repository: AdminMediaProcessorOpenAPIRepository

    func getAddMediaProcessor() async throws -> AdminAddMediaProcessorModel {
        .init(
            fileSuffix: "",
            matchExtensions: "",
            commandTemplate: "",
            error: nil
        )
    }

    func postAddMediaProcessor(
        payload: AddProcessorForm
    ) async throws -> AdminAddMediaProcessorModel {
        do {
            try await repository.createProcessor(form: payload)
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                fileSuffix: payload.fileSuffix,
                matchExtensions: payload.matchExtensions,
                commandTemplate: payload.commandTemplate,
                error: error.errorDescription
            )
        }
        return .init(
            fileSuffix: "",
            matchExtensions: "",
            commandTemplate: "",
            error: nil
        )
    }
}
