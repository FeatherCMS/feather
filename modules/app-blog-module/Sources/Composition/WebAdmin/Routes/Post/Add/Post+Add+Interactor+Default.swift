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
        let optionRepository: any Post.Add.OptionRepository.Interface

        func loadOptions() async throws -> BlogPostAssociationOptionsModel {
            try await optionRepository.loadOptions()
        }

        func execute(
            input: BlogPostFormInput
        ) async throws {
            try await repository.create(input: input)
        }
    }
}
