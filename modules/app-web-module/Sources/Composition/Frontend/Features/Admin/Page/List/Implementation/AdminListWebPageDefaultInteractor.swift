import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebPageDefaultInteractor:
    AdminListWebPageInteractor
{
    let repository: any AdminListWebPageRepository

    func listWebPages(
        page: Int,
        search: String?
    ) async throws -> AdminListWebPageModel {
        try await repository.listWebPages(page: page, search: search)
    }


}
