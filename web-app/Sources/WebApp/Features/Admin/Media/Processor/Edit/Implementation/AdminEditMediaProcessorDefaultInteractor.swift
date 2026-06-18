import Hummingbird

struct AdminEditMediaProcessorDefaultInteractor:
    AdminEditMediaProcessorInteractor
{
    let repository: AdminMediaProcessorOpenAPIRepository

    func getEditMediaProcessor(
        id: String
    ) async throws -> AdminEditMediaProcessorModel {
        let item = try await repository.getProcessor(id: id)
        return .init(
            id: id,
            fileSuffix: item.name,
            matchExtensions: item.matchExtensions,
            commandTemplate: item.commandTemplate,
            error: nil
        )
    }

    func postEditMediaProcessor(
        id: String,
        payload: AddProcessorForm
    ) async throws -> AdminEditMediaProcessorModel {
        do {
            try await repository.updateProcessor(
                id: id,
                form: payload
            )
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                id: id,
                fileSuffix: payload.fileSuffix,
                matchExtensions: payload.matchExtensions,
                commandTemplate: payload.commandTemplate,
                error: error.errorDescription
            )
        }
        return .init(
            id: id,
            fileSuffix: "",
            matchExtensions: "",
            commandTemplate: "",
            error: nil
        )
    }
}
