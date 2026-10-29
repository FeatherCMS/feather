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

extension Post.Add.Interactor {
    struct Default: Interface {
        let repository: any Post.Add.Repository.Interface

        func execute(
            input: Post.Form.Input
        ) async throws {
            try await repository.create(input: input)
        }
    }
}
