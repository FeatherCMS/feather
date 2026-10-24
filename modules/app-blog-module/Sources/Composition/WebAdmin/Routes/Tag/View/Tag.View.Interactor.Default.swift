import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.View.Interactor {
    struct Default: Interface {
        let repository: any Tag.View.Repository.Interface

        func execute(id: String) async throws -> Tag.View.Model {
            try await repository.get(id: id)
        }
    }
}
