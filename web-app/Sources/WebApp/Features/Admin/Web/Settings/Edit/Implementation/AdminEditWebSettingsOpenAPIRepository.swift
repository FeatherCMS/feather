import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditWebSettingsOpenAPIRepository:
    AdminEditWebSettingsRepository
{
    let api: AdminAPI
    private let loadUnauthorizedMessage =
        "Please sign in again to load web settings."
    private let loadForbiddenMessage =
        "Your account cannot access web settings."
    private let saveUnauthorizedMessage =
        "Please sign in again to save web settings."
    private let saveForbiddenMessage =
        "Your account cannot update web settings."

    func loadSettings() async throws -> AdminEditWebSettingsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webSettingsGet(
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let body = try okResponse.body.json
                return .init(
                    logo: body.logo,
                    logoDark: body.logoDark,
                    metaImage: body.metaImage,
                    primaryColor: body.primaryColor,
                    secondaryColor: body.secondaryColor,
                    tertiaryColor: body.tertiaryColor,
                    primaryFont: body.primaryFont,
                    secondaryFont: body.secondaryFont,
                    homePageId: body.homePageId,
                    homePage: try await loadHomePage(id: body.homePageId),
                    homePageOptions: try await loadHomePageOptions(),
                    locale: body.locale,
                    timezone: body.timezone,
                    title: body.title,
                    excerpt: body.excerpt,
                    noIndex: body.noIndex,
                    css: body.css,
                    js: body.js,
                    hasMissingVariables: false
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: loadUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: loadForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func saveSettings(
        input: AdminEditWebSettingsFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webSettingsUpdate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        logo: input.normalizedLogo,
                        logoDark: input.normalizedLogoDark,
                        metaImage: input.normalizedMetaImage,
                        primaryColor: input.normalizedPrimaryColor,
                        secondaryColor: input.normalizedSecondaryColor,
                        tertiaryColor: input.normalizedTertiaryColor,
                        primaryFont: input.normalizedPrimaryFont,
                        secondaryFont: input.normalizedSecondaryFont,
                        homePageId: input.normalizedHomePageId,
                        locale: input.normalizedLocale,
                        timezone: input.normalizedTimezone,
                        title: input.normalizedTitle,
                        excerpt: input.normalizedExcerpt,
                        noIndex: input.noIndex.value,
                        css: input.normalizedCSS,
                        js: input.normalizedJS
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: saveUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: saveForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func loadHomePage(
        id: String?
    ) async throws -> AdminEditWebSettingsHomePageModel? {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            guard let id, !id.isEmpty else {
                return nil
            }
            let response = try await client.webPageGet(
                path: .init(webPageId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let page = try okResponse.body.json
                return .init(
                    id: page.id,
                    title: page.title,
                    slug: page.metadata.slug
                )
            case .notFound:
                return nil
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: loadUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: loadForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func loadHomePageOptions() async throws
        -> [AdminEditWebSettingsHomePageModel]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let pageSize = 100
            var pageNumber = 1
            var items: [Components.Schemas.WebPageListItemSchema] = []

            while true {
                let response = try await client.webPageSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: pageSize, number: pageNumber),
                            filters: .init(search: nil)
                        )
                    )
                )

                let body: Components.Schemas.WebPageListItemSearchSchema
                switch response {
                case .ok(let okResponse):
                    body = try okResponse.body.json
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized(
                        message: loadUnauthorizedMessage
                    )
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden(
                        message: loadForbiddenMessage
                    )
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }

                items.append(contentsOf: body.data.items)
                if items.count >= body.data.total
                    || body.data.items.count < pageSize
                {
                    break
                }
                pageNumber += 1
            }

            let detailsRepository = AdminListWebPageFormOpenAPIRepository(api: api)
            return try await withThrowingTaskGroup(
                of: (Int, AdminEditWebSettingsHomePageModel).self
            ) { group in
                for (index, item) in items.enumerated() {
                    group.addTask {
                        let details = try await detailsRepository.load(id: item.id)
                        return (
                            index,
                            .init(
                                id: item.id,
                                title: item.title,
                                slug: details.metadata.slug
                            )
                        )
                    }
                }

                var options = [AdminEditWebSettingsHomePageModel?](
                    repeating: nil,
                    count: items.count
                )
                for try await (index, option) in group {
                    options[index] = option
                }
                return options.compactMap { $0 }
            }
        }
    }
}
