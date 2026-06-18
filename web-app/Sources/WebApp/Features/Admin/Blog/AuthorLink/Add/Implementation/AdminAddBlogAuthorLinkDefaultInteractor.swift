import Foundation

struct AdminAddBlogAuthorLinkDefaultInteractor: AdminAddBlogAuthorLinkInteractor
{
    let repository: any AdminAddBlogAuthorLinkRepository

    func execute(
        menuId: String,
        input: BlogAuthorLinkFormInput
    ) async throws {
        try await repository.create(menuId: menuId, input: input)
    }
}
