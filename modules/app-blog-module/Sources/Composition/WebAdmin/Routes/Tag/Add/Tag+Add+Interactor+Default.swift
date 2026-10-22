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

extension Tag.Add.Interactor {
    struct Default: Interface {
        let repository: any Tag.Add.Repository.Interface

        func execute(input: BlogTagFormInput) async throws {
            try await repository.create(input: input)
        }
    }
}
