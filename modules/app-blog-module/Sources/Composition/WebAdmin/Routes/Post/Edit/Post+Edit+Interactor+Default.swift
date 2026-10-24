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

extension Post.Edit.Interactor {
    struct Default: Interface {
        let repository: any Post.Edit.Repository.Interface
        let optionRepository: any Post.Association.Repository.Interface

        func load(
            id: String
        ) async throws -> Post.View.Model {
            try await repository.load(id: id)
        }

        func loadOptions() async throws -> Post.Association.Options {
            try await optionRepository.loadOptions()
        }

        func update(
            id: String,
            input: Post.Form.Input
        ) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
