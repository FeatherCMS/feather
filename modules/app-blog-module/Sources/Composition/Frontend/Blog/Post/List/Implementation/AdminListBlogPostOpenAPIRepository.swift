import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

struct AdminListBlogPostOpenAPIRepository:
    AdminListBlogPostRepository
{
    let api: BlogAdminAPIClient
    private let listUnauthorizedMessage =
        "Please sign in again to view blog posts."
    private let listForbiddenMessage =
        "Your account cannot access blog posts."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this blog post."
    private let deleteForbiddenMessage =
        "Your account cannot delete this blog post."
    private let deleteNotFoundMessage =
        "This blog post could not be found."

    init(api: BlogAdminAPIClient) {
        self.api = api
    }

    func listBlogPosts(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogPostModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .blogPostSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            filters: .init(search: search)
                        )
                    )
                )

            switch response {
            case .ok(let okResponse):
                let body = try okResponse.body.json
                let items = try await loadItems(body.data.items)
                return .init(
                    items: items,
                    total: body.data.total,
                    page: body.query.page.number,
                    pageSize: body.query.page.size
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: listUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: listForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func loadItems(
        _ items: [BlogAdminAPI.Components.Schemas.BlogPostListItemSchema]
    ) async throws -> [AdminListBlogPostItemModel] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            try await withThrowingTaskGroup(
                of: (Int, AdminListBlogPostItemModel).self
            ) { group in
                let repository = AdminListBlogPostFormOpenAPIRepository(
                    api: api
                )
                for (index, item) in items.enumerated() {
                    group.addTask {
                        let details = try await repository.load(id: item.id)
                        return (
                            index,
                            .init(
                                id: item.id,
                                title: item.title,
                                metadata: details.metadata
                            )
                        )
                    }
                }

                var enrichedItems = [AdminListBlogPostItemModel?](
                    repeating: nil,
                    count: items.count
                )
                for try await (index, item) in group {
                    enrichedItems[index] = item
                }
                return enrichedItems.compactMap { $0 }
            }
        }
    }

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.blogPostDelete(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }

}
