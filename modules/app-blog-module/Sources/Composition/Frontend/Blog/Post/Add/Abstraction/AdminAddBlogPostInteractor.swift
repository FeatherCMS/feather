import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

protocol AdminAddBlogPostInteractor: Sendable {

    func loadOptions() async throws -> BlogPostAssociationOptionsModel

    func execute(
        input: BlogPostFormInput
    ) async throws
}
