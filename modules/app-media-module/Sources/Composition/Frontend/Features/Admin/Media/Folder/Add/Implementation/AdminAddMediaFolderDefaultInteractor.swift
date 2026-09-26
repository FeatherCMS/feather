import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaFolderDefaultInteractor: AdminAddMediaFolderInteractor {
    let repository: AdminAddMediaFolderOpenAPIRepository

    func getAddMediaFolder(
        parentId: String?,
        view: String
    ) async throws -> AdminAddMediaFolderModel {
        .init(
            parentId: parentId,
            name: "",
            view: view,
            error: nil
        )
    }

    func postAddMediaFolder(
        payload: MediaFolderAddForm
    ) async throws -> AdminAddMediaFolderModel {
        do {
            try await repository.createFolder(
                name: payload.normalizedName,
                parentId: payload.normalizedParentId
            )
        }
        catch let error as OpenAPIRepositoryError {
            let message: String
            switch error {
            case .conflict:
                message =
                    "A folder with this name already exists in this location."
            case .failure(let failure)
                where failure.backendError?.trace?.containsDuplicatePath == true:
                message =
                    "A folder with this name already exists in this location."
            default:
                message =
                    "Failed to create media folder: \(error.errorDescription)"
            }
            return .init(
                parentId: payload.normalizedParentId,
                name: payload.name,
                view: payload.view,
                error: message
            )
        }
        return .init(
            parentId: payload.normalizedParentId,
            name: "",
            view: payload.view,
            error: nil
        )
    }
}

private extension OpenAPIRepositoryError.BackendError.Trace {
    var containsDuplicatePath: Bool {
        if id == "MediaApplication.CreateMediaFolder.Error",
           message == "duplicatePath"
        {
            return true
        }

        return reasons?.contains(where: { $0.containsDuplicatePath }) == true
    }
}
