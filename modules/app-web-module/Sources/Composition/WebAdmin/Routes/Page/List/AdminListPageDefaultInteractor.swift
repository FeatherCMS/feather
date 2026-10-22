import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListPageDefaultInteractor:
    AdminListPageInteractor
{
    let repository: any AdminListPageRepository

    func listPages(
        page: Int,
        search: String?
    ) async throws -> AdminListPageModel {
        try await repository.listPages(page: page, search: search)
    }

}
