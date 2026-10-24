import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Add.Interactor {
    struct Default: Interface {
        let repository: any Asset.File.Add.Repository.Interface
        let routes: Asset.Router.Routes

        func folderID(forPath path: String) async throws -> String? {
            let components =
                path
                .split(separator: "/")
                .map { $0.whitespaceTrimmed }
                .filter { !$0.isEmpty }
            guard !components.isEmpty else { return nil }

            var parentID: String?
            for name in components {
                let folders = try await repository.listFolders(
                    parentId: parentID
                )
                if let folder = folders.first(where: {
                    $0.name.caseInsensitiveCompare(name) == .orderedSame
                }) {
                    parentID = folder.id
                    continue
                }

                do {
                    try await repository.createFolder(
                        name: name,
                        parentId: parentID
                    )
                }
                catch let error as OpenAPIRepositoryError {
                    guard case .conflict = error else { throw error }
                }

                let resolvedFolders = try await repository.listFolders(
                    parentId: parentID
                )
                guard
                    let folder = resolvedFolders.first(where: {
                        $0.name.caseInsensitiveCompare(name) == .orderedSame
                    })
                else {
                    return nil
                }
                parentID = folder.id
            }
            return parentID
        }

        func getAddMediaAsset() async throws -> Asset.File.Add.Model {
            .init(
                parentId: "",
                fileName: "",
                extension: "bin",
                title: "",
                altText: "",
                data: "",
                error: nil,
                view: "grid",
                action: routes.file.add.path,
                isPicker: false,
                selectedAsset: nil
            )
        }

        func postAddMediaAsset(
            payload: Asset.File.Add.Upload.Payload,
            variants: [String]?
        ) async throws -> Asset.File.Add.Model {
            do {
                let asset = try await repository.createAsset(
                    payload: payload,
                    variants: variants
                )
                return .init(
                    parentId: "",
                    fileName: "",
                    extension: "bin",
                    title: "",
                    altText: "",
                    data: "",
                    error: nil,
                    view: payload.view,
                    action: routes.file.add.path,
                    isPicker: false,
                    selectedAsset: asset
                )
            }
            catch let error as OpenAPIRepositoryError {
                let message: String
                switch error {
                case .conflict:
                    message =
                        "A media asset with this name already exists in this location."
                case .failure(let failure)
                where failure.backendError?.trace?.containsDuplicatePath == true:
                    message =
                        "A media asset with this name already exists in this location."
                default:
                    message =
                        "Failed to create media asset: \(error.errorDescription)"
                }
                return .init(
                    parentId: payload.parentId,
                    fileName: payload.fileName,
                    extension: payload.extension,
                    title: payload.title,
                    altText: payload.altText,
                    data: "",
                    error: message,
                    view: payload.view,
                    action: routes.file.add.path,
                    isPicker: false,
                    selectedAsset: nil
                )
            }
        }
    }
}

extension OpenAPIRepositoryError.BackendError.Trace {
    fileprivate var containsDuplicatePath: Bool {
        if id == "MediaApplication.Asset.File.Add.Error",
            message == "duplicatePath"
        {
            return true
        }

        return reasons?.contains(where: { $0.containsDuplicatePath }) == true
    }
}
