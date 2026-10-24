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

extension AuthorLink.Add.Interactor {
    struct Default: Interface {
        let repository: any AuthorLink.Add.Repository.Interface

        func execute(
            authorID: String,
            input: AuthorLink.Form.Input
        ) async throws {
            try await repository.create(authorID: authorID, input: input)
        }
    }
}
