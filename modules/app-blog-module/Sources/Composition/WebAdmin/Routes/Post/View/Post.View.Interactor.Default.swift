import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Post.View.Interactor {
    struct Default: Interface {
        let repository: any Post.View.Repository.Interface

        func execute(id: String) async throws -> Post.View.Model {
            try await repository.get(id: id)
        }
    }
}
