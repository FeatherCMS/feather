import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Remove.Interactor {
    struct Default: Asset.File.Remove.Interactor.Interface {
        let repository: Asset.File.Remove.Repository.OpenAPI

        func remove(ids: [String]) async throws {
            for id in ids {
                try await repository.deleteAsset(id: id)
            }
        }
    }
}
