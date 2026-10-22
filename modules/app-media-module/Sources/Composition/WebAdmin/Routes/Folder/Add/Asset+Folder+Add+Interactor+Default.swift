import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Add.Interactor {
    struct Default: Asset.Folder.Add.Interactor.Interface {
        let repository: Asset.Folder.Add.Repository.OpenAPI

        func getAddMediaFolder(
            parentId: String?,
            view: String
        ) async throws -> Asset.Folder.Add.Model {
            .init(
                parentId: parentId,
                name: "",
                view: view,
                error: nil
            )
        }

        func postAddMediaFolder(
            payload: MediaFolderAddForm
        ) async throws -> Asset.Folder.Add.Model {
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
    }

    extension OpenAPIRepositoryError.BackendError.Trace {
    fileprivate var containsDuplicatePath: Bool {
        if id == "MediaApplication.Asset.Folder.Add.Error",
            message == "duplicatePath"
        {
            return true
        }

        return reasons?.contains(where: { $0.containsDuplicatePath }) == true
    }
}
