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
        let repository: any Tag.Detail.Repository.Interface

        func execute(_ input: Tag.View.Model) async throws -> Tag.Detail.Model {
            try await repository.get(id: input.id)
        }
    }
}
