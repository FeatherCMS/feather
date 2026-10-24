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

extension Author.View.Interactor {
    struct Default: Interface {
        let repository: any Author.View.Repository.Interface

        func execute(id: String) async throws -> Author.View.Model {
            try await repository.get(id: id)
        }
    }
}
