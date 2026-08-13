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
import WebStandards

struct AdminAddBlogAuthorDefaultInteractor: AdminAddBlogAuthorInteractor {
    let repository: any AdminAddBlogAuthorRepository

    func execute(
        input: BlogAuthorFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
