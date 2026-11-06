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
    struct Default: Interface {
        let repository: any Asset.File.Remove.Repository.Interface

        func remove(ids: [String]) async throws {
            for id in ids {
                try await repository.deleteAsset(id: id)
            }
        }
    }
}
