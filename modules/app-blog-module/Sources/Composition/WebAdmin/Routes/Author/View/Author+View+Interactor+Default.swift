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
        let repository: any Author.Detail.Repository.Interface

        func execute(entity: Author.View.Model) async throws
            -> Author.Detail.Model
        {
            try await repository.get(id: entity.id)
        }
    }
}
