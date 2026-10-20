import BlogAdminAPI
import BlogAppAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminAddBlogPostInteractor: Sendable {

    func loadOptions() async throws -> BlogPostAssociationOptionsModel

    func execute(
        input: BlogPostFormInput
    ) async throws
}
