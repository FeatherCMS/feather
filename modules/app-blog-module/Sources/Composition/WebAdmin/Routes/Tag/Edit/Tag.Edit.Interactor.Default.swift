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

extension Tag.Edit.Interactor {
    struct Default: Interface {
        let repository: any Tag.Edit.Repository.Interface

        func load(id: String) async throws -> Tag.View.Model {
            try await repository.load(id: id)
        }

        func update(id: String, input: Tag.Form.Input) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
