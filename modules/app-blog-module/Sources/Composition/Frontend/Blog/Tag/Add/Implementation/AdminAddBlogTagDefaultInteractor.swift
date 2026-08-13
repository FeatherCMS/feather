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

struct AdminAddBlogTagDefaultInteractor: AdminAddBlogTagInteractor {
    let repository: any AdminAddBlogTagRepository

    func execute(
        input: BlogTagFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
