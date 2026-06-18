import AdminOpenAPI
import Foundation

struct AdminMediaProcessorOpenAPIRepository {
    let api: AdminAPI
    private let listUnauthorizedMessage =
        "Please sign in again to view media processors."
    private let getUnauthorizedMessage =
        "Please sign in again to load this media processor."
    private let createUnauthorizedMessage =
        "Please sign in again to create this media processor."
    private let updateUnauthorizedMessage =
        "Please sign in again to update this media processor."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this media processor."

    init(api: AdminAPI) {
        self.api = api
    }

    func listProcessors(
        page: Int
    ) async throws -> (
        items: [Components.Schemas.MediaProcessorListItemSchema], total: Int,
        page: Int, pageSize: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaProcessorSearch(
                    body: .json(
                        .init(
                            page: .init(size: 100, number: page),
                            sort: [.init(field: .name, direction: .asc)],
                            filters: .init(search: nil)
                        )
                    )
                )
            switch response {
            case .ok(let ok):
                let body = try ok.body.json
                return (
                    items: body.data.items,
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
                    message: "Your account cannot access media processors."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func getProcessor(
        id: String
    ) async throws -> Components.Schemas.MediaProcessorDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaProcessorGet(
                    path: .init(mediaProcessorId: id)
                )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media processor not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: getUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access media processors."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func createProcessor(
        form: AddProcessorForm
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaProcessorCreate(
                    body: .json(
                        .init(
                            name: form.fileSuffix,
                            matchExtensions: form.matchExtensions,
                            commandTemplate: form.commandTemplate
                        )
                    )
                )
            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: createUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create media processors."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func updateProcessor(
        id: String,
        form: AddProcessorForm
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaProcessorUpdate(
                    path: .init(mediaProcessorId: id),
                    body: .json(
                        .init(
                            name: form.fileSuffix,
                            matchExtensions: form.matchExtensions,
                            commandTemplate: form.commandTemplate
                        )
                    )
                )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media processor not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: updateUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit media processors."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func deleteProcessor(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaProcessorDelete(
                    path: .init(mediaProcessorId: id)
                )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media processor not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: deleteUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete media processors."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func delete(
        id: String
    ) async throws {
        try await deleteProcessor(id: id)
    }
}
