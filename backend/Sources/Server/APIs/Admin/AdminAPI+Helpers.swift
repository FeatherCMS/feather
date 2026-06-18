import Application
import SystemApplication
import AnalyticsApplication
import WebApplication
import WebDomain
import RedirectApplication
import WebApplication
import BlogApplication
import AuthApplication
import UserApplication
import MediaApplication
import Foundation
import AdminOpenAPI

extension AdminAPI {

    func emptyToNil(
        _ value: String
    ) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    func timestamp(
        _ date: Date
    ) -> Double {
        date.timeIntervalSince1970
    }

    func mapMetadataStatus(
        _ value: String?
    ) -> Metadata.Status {
        value.flatMap(Metadata.Status.init(rawValue:)) ?? .draft
    }

    func mapBlogMetadata(
        _ metadata: Components.Schemas.WebMetadataCreateSchema
    ) -> BlogMetadataInput {
        .init(
            slug: metadata.slug,
            publicationDate: metadata.publicationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            expirationDate: metadata.expirationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            status: mapMetadataStatus(metadata.status),
            title: metadata.title,
            excerpt: metadata.excerpt,
            imageURL: metadata.imageUrl,
            canonicalURL: metadata.canonicalUrl ?? "",
            noIndex: metadata.noIndex ?? false,
            primaryKeyword: metadata.primaryKeyword ?? "",
            cssCodeInjection: metadata.cssCodeInjection ?? "",
            javascriptCodeInjection: metadata.javascriptCodeInjection ?? "",
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
                ?? ""
        )
    }

    func mapPageMetadata(
        _ metadata: Components.Schemas.WebMetadataCreateSchema
    ) -> PageMetadataInput {
        .init(
            slug: metadata.slug,
            publicationDate: metadata.publicationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            expirationDate: metadata.expirationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            status: mapMetadataStatus(metadata.status),
            title: metadata.title,
            excerpt: metadata.excerpt,
            imageURL: metadata.imageUrl,
            canonicalURL: metadata.canonicalUrl ?? "",
            noIndex: metadata.noIndex ?? false,
            primaryKeyword: metadata.primaryKeyword ?? "",
            cssCodeInjection: metadata.cssCodeInjection ?? "",
            javascriptCodeInjection: metadata.javascriptCodeInjection ?? "",
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
                ?? ""
        )
    }

    func mergeBlogMetadata(
        _ patch: Components.Schemas.WebMetadataPatchSchema,
        into detail: Components.Schemas.WebMetadataDetailSchema
    ) -> BlogMetadataInput {
        .init(
            slug: patch.slug ?? detail.slug,
            publicationDate: (patch.publicationDate ?? detail.publicationDate)
                .map(Date.init(timeIntervalSince1970:)),
            expirationDate: (patch.expirationDate ?? detail.expirationDate)
                .map(Date.init(timeIntervalSince1970:)),
            status: mapMetadataStatus(patch.status ?? detail.status),
            title: patch.title ?? detail.title,
            excerpt: patch.excerpt ?? detail.excerpt,
            imageURL: patch.imageUrl ?? detail.imageUrl,
            canonicalURL: patch.canonicalUrl ?? (detail.canonicalUrl ?? ""),
            noIndex: patch.noIndex ?? detail.noIndex,
            primaryKeyword: patch.primaryKeyword ?? detail.primaryKeyword,
            cssCodeInjection: patch.cssCodeInjection
                ?? (detail.cssCodeInjection ?? ""),
            javascriptCodeInjection: patch.javascriptCodeInjection
                ?? (detail.javascriptCodeInjection ?? ""),
            structuredDataCodeInjection: patch.structuredDataCodeInjection
                ?? (detail.structuredDataCodeInjection ?? "")
        )
    }

    func mergePageMetadata(
        _ patch: Components.Schemas.WebMetadataPatchSchema,
        into detail: Components.Schemas.WebMetadataDetailSchema
    ) -> PageMetadataInput {
        .init(
            slug: patch.slug ?? detail.slug,
            publicationDate: (patch.publicationDate ?? detail.publicationDate)
                .map(Date.init(timeIntervalSince1970:)),
            expirationDate: (patch.expirationDate ?? detail.expirationDate)
                .map(Date.init(timeIntervalSince1970:)),
            status: mapMetadataStatus(patch.status ?? detail.status),
            title: patch.title ?? detail.title,
            excerpt: patch.excerpt ?? detail.excerpt,
            imageURL: patch.imageUrl ?? detail.imageUrl,
            canonicalURL: patch.canonicalUrl ?? (detail.canonicalUrl ?? ""),
            noIndex: patch.noIndex ?? detail.noIndex,
            primaryKeyword: patch.primaryKeyword ?? detail.primaryKeyword,
            cssCodeInjection: patch.cssCodeInjection
                ?? (detail.cssCodeInjection ?? ""),
            javascriptCodeInjection: patch.javascriptCodeInjection
                ?? (detail.javascriptCodeInjection ?? ""),
            structuredDataCodeInjection: patch.structuredDataCodeInjection
                ?? (detail.structuredDataCodeInjection ?? "")
        )
    }

    func mapSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc:
            .asc
        case .desc:
            .desc
        }
    }

    func map(
        _ page: Components.Schemas.SearchPageSchema
    ) -> Search.Page {
        .init(size: page.size, number: page.number)
    }

    func map(
        _ query: Components.Schemas.AnalyticsLogListItemSearchQuerySchema
    ) -> LogList.Query {
        let sort = (query.sort ?? [])
            .map { log in
                let field: LogList.Query.Sort.Field
                switch log.field {
                case .id:
                    field = .id
                case .accountId:
                    field = .accountId
                case .method:
                    field = .method
                case .source:
                    field = .source
                case .path:
                    field = .path
                case .responseCode:
                    field = .responseCode
                case .ip:
                    field = .ip
                case .browserName:
                    field = .browserName
                case .createdAt:
                    field = .createdAt
                }
                return LogList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(log.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: emptyToNil(query.filters.search ?? ""),
            source: emptyToNil(query.filters.source ?? ""),
            method: emptyToNil(query.filters.method ?? ""),
            responseCode: query.filters.responseCode
        )
    }

    func map(
        _ item: LogList.Item
    ) -> Components.Schemas.AnalyticsLogListItemSchema {
        .init(
            id: item.id,
            accountId: item.accountId ?? "",
            source: item.source,
            method: item.method,
            path: item.path,
            responseCode: item.responseCode,
            ip: item.ip ?? "",
            browserName: item.browserName ?? "",
            createdAt: item.createdAt
        )
    }

    func map(
        _ query: Components.Schemas.AnalyticsLogOverviewQuerySchema
    ) -> LogOverview.Query {
        .init(
            source: query.source,
            from: query.from,
            to: query.to
        )
    }

    func map(
        _ item: LogOverview.BreakdownItem
    ) -> Components.Schemas.AnalyticsLogOverviewBreakdownItemSchema {
        .init(
            label: item.label,
            count: item.count,
            share: item.share
        )
    }

    func map(
        _ item: LogOverview.DailyPoint
    ) -> Components.Schemas.AnalyticsLogOverviewDailyPointSchema {
        .init(
            bucket: item.bucket,
            requests: item.requests,
            notFoundRequests: item.notFoundRequests,
            clientErrorRequests: item.clientErrorRequests,
            serverErrorRequests: item.serverErrorRequests
        )
    }

    func map(
        _ overview: LogOverview
    ) -> Components.Schemas.AnalyticsLogOverviewSchema {
        .init(
            query: .init(
                source: overview.query.source,
                from: overview.query.from,
                to: overview.query.to
            ),
            kpis: .init(
                totalRequests: overview.kpis.totalRequests,
                averageRequestsPerDay: overview.kpis.averageRequestsPerDay,
                authenticatedRequests: overview.kpis.authenticatedRequests,
                notFoundRequests: overview.kpis.notFoundRequests,
                clientErrorRequests: overview.kpis.clientErrorRequests,
                serverErrorRequests: overview.kpis.serverErrorRequests
            ),
            daily: overview.daily.map(map),
            statusFamilies: overview.statusFamilies.map(map),
            methods: overview.methods.map(map),
            paths: overview.paths.map(map),
            notFoundPaths: overview.notFoundPaths.map(map),
            serverErrorPaths: overview.serverErrorPaths.map(map),
            referrers: overview.referrers.map(map),
            browsers: overview.browsers.map(map),
            operatingSystems: overview.operatingSystems.map(map),
            deviceTypes: overview.deviceTypes.map(map),
            languages: overview.languages.map(map),
            regions: overview.regions.map(map)
        )
    }

    func map(
        _ detail: LogDetail
    ) -> Components.Schemas.AnalyticsLogDetailSchema {
        .init(
            id: detail.id,
            accountId: detail.accountId ?? "",
            source: detail.source,
            method: detail.method,
            url: detail.url,
            headers: detail.headers,
            ip: detail.ip ?? "",
            path: detail.path,
            referer: detail.referer ?? "",
            origin: detail.origin ?? "",
            acceptLanguage: detail.acceptLanguage ?? "",
            userAgent: detail.userAgent ?? "",
            language: detail.language ?? "",
            region: detail.region ?? "",
            osName: detail.osName ?? "",
            osVersion: detail.osVersion ?? "",
            browserName: detail.browserName ?? "",
            browserVersion: detail.browserVersion ?? "",
            engineName: detail.engineName ?? "",
            engineVersion: detail.engineVersion ?? "",
            deviceVendor: detail.deviceVendor ?? "",
            deviceType: detail.deviceType ?? "",
            deviceModel: detail.deviceModel ?? "",
            cpu: detail.cpu ?? "",
            responseCode: detail.responseCode,
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt
        )
    }

    func map(
        _ query: Components.Schemas.SystemVariableListItemSearchQuerySchema
    ) -> VariableList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: VariableList.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .name:
                    field = .name
                case .value:
                    field = .value
                case .notes:
                    field = .notes
                }
                return VariableList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ query: Components.Schemas.WebMetadataListItemSearchQuerySchema
    ) -> MetadataList.Query {
        let sort = (query.sort ?? [])
            .map { entry in
                let field: MetadataList.Query.Sort.Field
                switch entry.field {
                case .id:
                    field = .id
                case .slug:
                    field = .slug
                case .publicationDate:
                    field = .publicationDate
                case .expirationDate:
                    field = .expirationDate
                case .status:
                    field = .status
                case .title:
                    field = .title
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return MetadataList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(entry.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: MetadataDetail
    ) -> Components.Schemas.WebMetadataDetailSchema {
        .init(
            id: detail.id,
            referenceType: detail.referenceType ?? "",
            referenceId: detail.referenceID ?? "",
            slug: detail.slug,
            publicationDate: timestamp(detail.publicationDate),
            expirationDate: timestamp(detail.expirationDate),
            status: detail.status.rawValue,
            title: detail.title,
            excerpt: detail.excerpt,
            imageUrl: detail.imageURL,
            canonicalUrl: detail.canonicalURL,
            noIndex: detail.noIndex,
            primaryKeyword: detail.primaryKeyword,
            cssCodeInjection: detail.cssCodeInjection,
            javascriptCodeInjection: detail.javascriptCodeInjection,
            structuredDataCodeInjection: detail.structuredDataCodeInjection,
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ item: MetadataList.Item
    ) -> Components.Schemas.WebMetadataListItemSchema {
        .init(
            id: item.id,
            referenceType: item.referenceType ?? "",
            referenceId: item.referenceID ?? "",
            slug: item.slug,
            publicationDate: timestamp(item.publicationDate),
            expirationDate: timestamp(item.expirationDate),
            status: item.status.rawValue,
            title: item.title,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func timestamp(
        _ date: Date?
    ) -> Double? {
        guard let date else {
            return nil
        }
        return timestamp(date)
    }

    func map(
        _ query: Components.Schemas.RedirectRuleListItemSearchQuerySchema
    ) -> RuleList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: RuleList.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .source:
                    field = .source
                case .destination:
                    field = .destination
                case .statusCode:
                    field = .statusCode
                case .notes:
                    field = .notes
                }
                return RuleList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: RuleDetail
    ) -> Components.Schemas.RedirectRuleDetailSchema {
        .init(
            id: detail.id,
            source: detail.source,
            destination: detail.destination,
            statusCode: detail.statusCode,
            notes: detail.notes
        )
    }

    func map(
        _ item: RuleList.Item
    ) -> Components.Schemas.RedirectRuleListItemSchema {
        .init(
            id: item.id,
            source: item.source,
            destination: item.destination,
            statusCode: item.statusCode
        )
    }

    func map(
        _ query: Components.Schemas.BlogPostListItemSearchQuerySchema
    ) -> PostList.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: PostList.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .title:
                    field = .title
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return PostList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(item.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: PostDetail
    ) -> Components.Schemas.BlogPostDetailSchema {
        .init(
            id: detail.id,
            title: detail.title,
            excerpt: detail.excerpt,
            content: detail.content,
            imageAssetId: detail.imageAssetId,
            authorIds: detail.authorIds,
            tagIds: detail.tagIds,
            metadata: map(detail.metadata),
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ item: PostList.Item
    ) -> Components.Schemas.BlogPostListItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func map(
        _ query: Components.Schemas.BlogTagListItemSearchQuerySchema
    ) -> TagList.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: TagList.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .title:
                    field = .title
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return TagList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(item.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: TagDetail
    ) -> Components.Schemas.BlogTagDetailSchema {
        .init(
            id: detail.id,
            title: detail.title,
            excerpt: detail.excerpt,
            content: detail.content,
            imageAssetId: detail.imageAssetId,
            metadata: map(detail.metadata),
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ item: TagList.Item
    ) -> Components.Schemas.BlogTagListItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func map(
        _ query: Components.Schemas.BlogAuthorListItemSearchQuerySchema
    ) -> AuthorList.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: AuthorList.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .key:
                    field = .name
                case .name:
                    field = .name
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return AuthorList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(item.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: AuthorDetail
    ) -> Components.Schemas.BlogAuthorDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            excerpt: detail.excerpt,
            content: detail.content,
            profileImageAssetId: detail.profileImageAssetId,
            metadata: map(detail.metadata),
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ item: AuthorList.Item
    ) -> Components.Schemas.BlogAuthorListItemSchema {
        .init(
            id: item.id,
            name: item.name,
            excerpt: item.excerpt,
            profileImageAssetId: item.profileImageAssetId,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func map(
        _ query: Components.Schemas.BlogAuthorLinkListItemSearchQuerySchema
    ) -> AuthorLinkList.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: AuthorLinkList.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .label:
                    field = .label
                case .url:
                    field = .url
                case .priority:
                    field = .priority
                case .permission:
                    field = .permission
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return AuthorLinkList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(item.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: AuthorLinkDetail
    ) -> Components.Schemas.BlogAuthorLinkDetailSchema {
        .init(
            id: detail.id,
            menuId: detail.authorId,
            label: detail.label,
            url: detail.url,
            priority: detail.priority,
            isBlank: detail.isBlank,
            permission: detail.permission,
            notes: detail.notes,
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ item: AuthorLinkList.Item
    ) -> Components.Schemas.BlogAuthorLinkListItemSchema {
        .init(
            id: item.id,
            menuId: item.authorId,
            label: item.label,
            url: item.url,
            priority: item.priority,
            isBlank: item.isBlank,
            permission: item.permission,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func map(
        _ query: Components.Schemas.WebPageListItemSearchQuerySchema
    ) -> PageList.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: PageList.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .title:
                    field = .title
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return PageList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(item.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: PageDetail
    ) -> Components.Schemas.WebPageDetailSchema {
        .init(
            id: detail.id,
            title: detail.title,
            excerpt: detail.excerpt,
            content: detail.content,
            imageAssetId: detail.imageAssetId,
            metadata: map(detail.metadata),
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ item: PageList.Item
    ) -> Components.Schemas.WebPageListItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func map(
        _ query: Components.Schemas.WebMenuListItemSearchQuerySchema
    ) -> MenuList.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: MenuList.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .key:
                    field = .key
                case .name:
                    field = .name
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return MenuList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(item.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: MenuDetail
    ) -> Components.Schemas.WebMenuDetailSchema {
        .init(
            id: detail.id,
            key: detail.key,
            name: detail.name,
            notes: detail.notes,
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ item: MenuList.Item
    ) -> Components.Schemas.WebMenuListItemSchema {
        .init(
            id: item.id,
            key: item.key,
            name: item.name,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func map(
        _ query: Components.Schemas.WebMenuItemListItemSearchQuerySchema
    ) -> MenuItemList.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: MenuItemList.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .label:
                    field = .label
                case .url:
                    field = .url
                case .priority:
                    field = .priority
                case .permission:
                    field = .permission
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return MenuItemList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(item.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: MenuItemDetail
    ) -> Components.Schemas.WebMenuItemDetailSchema {
        .init(
            id: detail.id,
            menuId: detail.menuId,
            label: detail.label,
            url: detail.url,
            priority: detail.priority,
            isBlank: detail.isBlank,
            permission: detail.permission,
            notes: detail.notes,
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ item: MenuItemList.Item
    ) -> Components.Schemas.WebMenuItemListItemSchema {
        .init(
            id: item.id,
            menuId: item.menuId,
            label: item.label,
            url: item.url,
            priority: item.priority,
            isBlank: item.isBlank,
            permission: item.permission,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func map(
        _ detail: WebApplication.SettingsDetail
    ) -> Components.Schemas.WebSettingsDetailSchema {
        .init(
            id: detail.id,
            logo: detail.logo,
            logoDark: detail.logoDark,
            metaImage: detail.metaImage,
            primaryColor: detail.primaryColor,
            secondaryColor: detail.secondaryColor,
            tertiaryColor: detail.tertiaryColor,
            primaryFont: detail.primaryFont,
            secondaryFont: detail.secondaryFont,
            homePageId: detail.homePageId,
            locale: detail.locale,
            timezone: detail.timezone,
            title: detail.title,
            excerpt: detail.excerpt,
            noIndex: detail.noIndex,
            css: detail.css,
            js: detail.js
        )
    }

    func map(
        _ detail: BlogApplication.SettingsDetail
    ) -> Components.Schemas.BlogSettingsDetailSchema {
        .init(
            id: detail.id,
            postListPath: detail.postListPath,
            authorListPath: detail.authorListPath,
            tagListPath: detail.tagListPath,
            postPathPrefix: detail.postPathPrefix,
            authorPathPrefix: detail.authorPathPrefix,
            tagPathPrefix: detail.tagPathPrefix
        )
    }

    func map(
        _ detail: VariableDetail
    ) -> Components.Schemas.SystemVariableDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            value: detail.value,
            notes: detail.notes
        )
    }

    func map(
        _ item: VariableList.Item
    ) -> Components.Schemas.SystemVariableListItemSchema {
        .init(
            id: item.id,
            name: item.name,
            value: item.value
        )
    }

    func map(
        _ query: Components.Schemas.SystemPermissionListItemSearchQuerySchema
    ) -> PermissionList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: PermissionList.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .name:
                    field = .name
                case .notes:
                    field = .notes
                }
                return PermissionList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: PermissionDetail
    ) -> Components.Schemas.SystemPermissionDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            notes: detail.notes
        )
    }

    func map(
        _ item: PermissionList.Item
    ) -> Components.Schemas.SystemPermissionListItemSchema {
        .init(
            id: item.id,
            name: item.name
        )
    }

    func map(
        _ query: Components.Schemas.UserAccountListItemSearchQuerySchema
    ) -> AccountList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: AccountList.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .email:
                    field = .id
                }
                return AccountList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: AccountDetail
    ) -> Components.Schemas.UserAccountDetailSchema {
        .init(
            id: detail.id,
            email: detail.email,
            roleIds: detail.roleIds
        )
    }

    func map(
        _ item: AccountList.Item
    ) -> Components.Schemas.UserAccountListItemSchema {
        .init(
            id: item.id,
            email: item.email
        )
    }

    func map(
        _ item: SessionList.Item
    ) -> Components.Schemas.UserAuthSessionListItemSchema {
        .init(
            id: item.id,
            expiresAt: item.expiresAt,
            isPersistent: item.isPersistent,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ query: Components.Schemas.UserRoleListItemSearchQuerySchema
    ) -> RoleList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: RoleList.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .name, .notes:
                    field = .id
                }
                return RoleList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: RoleDetail
    ) -> Components.Schemas.UserRoleDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            notes: detail.notes
        )
    }

    func map(
        _ item: RoleList.Item
    ) -> Components.Schemas.UserRoleListItemSchema {
        .init(
            id: item.id,
            name: item.name
        )
    }

    func map(
        _ query: Components.Schemas.UserRolePermissionListItemSearchQuerySchema
    ) -> RolePermissionList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: RolePermissionList.Query.Sort.Field
                switch rule.field {
                case .roleId:
                    field = .roleId
                case .permissionId:
                    field = .permissionId
                }
                return RolePermissionList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: RolePermissionDetail
    ) -> Components.Schemas.UserRolePermissionDetailSchema {
        .init(
            roleId: detail.roleId,
            permissionId: detail.permissionId
        )
    }

    func map(
        _ item: RolePermissionList.Item
    ) -> Components.Schemas.UserRolePermissionListItemSchema {
        .init(
            roleId: item.roleId,
            permissionId: item.permissionId
        )
    }

    func map(
        _ query: Components.Schemas.UserInvitationListItemSearchQuerySchema
    ) -> InvitationList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: InvitationList.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .email, .token, .expiresAt:
                    field = .id
                }
                return InvitationList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: InvitationDetail
    ) -> Components.Schemas.UserInvitationDetailSchema {
        .init(
            id: detail.id,
            email: detail.email,
            token: detail.token,
            expiresAt: detail.expiresAt.timeIntervalSince1970
        )
    }

    func map(
        _ item: InvitationList.Item
    ) -> Components.Schemas.UserInvitationListItemSchema {
        .init(
            id: item.id,
            email: item.email,
            token: item.token,
            expiresAt: item.expiresAt.timeIntervalSince1970
        )
    }

    func map(
        _ query: Components.Schemas.UserMagicLinkListItemSearchQuerySchema
    ) -> MagicLinkList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: MagicLinkList.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .email:
                    field = .id
                case .token:
                    field = .id
                case .expiresAt:
                    field = .id
                case .isPersistent:
                    field = .id
                case .isUsed:
                    field = .id
                }
                return MagicLinkList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: MagicLinkDetail
    ) -> Components.Schemas.UserMagicLinkDetailSchema {
        .init(
            id: detail.id,
            email: detail.email,
            token: detail.token,
            expiresAt: detail.expiresAt.timeIntervalSince1970,
            isPersistent: detail.isPersistent,
            isUsed: detail.isUsed
        )
    }

    func map(
        _ item: MagicLinkList.Item
    ) -> Components.Schemas.UserMagicLinkListItemSchema {
        .init(
            id: item.id,
            email: item.email,
            token: item.token,
            expiresAt: item.expiresAt.timeIntervalSince1970,
            isPersistent: item.isPersistent,
            isUsed: item.isUsed
        )
    }

    func map(
        _ query: Components.Schemas.MediaAssetListItemSearchQuerySchema
    ) -> MediaAssetList.Query {
        let sort: [MediaAssetList.Query.Sort] = (query.sort ?? [])
            .map { rule in
                let field: MediaAssetList.Query.Sort.Field
                switch rule.field {
                case .id: field = .id
                case .storageKey: field = .storageKey
                case ._type: field = .type
                case .sizeBytes: field = .sizeBytes
                case .status: field = .status
                case .title: field = .title
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return MediaAssetList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search,
            parentId: emptyToNil(query.filters.parentId ?? "")
        )
    }

    func map(
        _ detail: MediaAssetDetail
    ) -> Components.Schemas.MediaAssetDetailSchema {
        .init(
            id: detail.id,
            folderId: detail.folderId,
            storageKey: detail.storageKey,
            baseName: detail.baseName,
            _type: detail.type,
            sizeBytes: detail.sizeBytes,
            status: detail.status,
            title: detail.title,
            altText: detail.altText,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ item: MediaAssetList.Item
    ) -> Components.Schemas.MediaAssetListItemSchema {
        .init(
            id: item.id,
            folderId: item.folderId,
            storageKey: item.storageKey,
            baseName: item.baseName,
            _type: item.type,
            sizeBytes: item.sizeBytes,
            status: item.status,
            title: item.title,
            altText: item.altText,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ item: MediaModule.AssociatedVariantFile
    ) -> Components.Schemas.MediaAssetVariantListItemSchema {
        .init(
            variantId: item.variantId,
            name: item.name,
            _type: item.type,
            storageKey: item.storageKey
        )
    }

    func map(
        _ query: Components.Schemas.MediaFolderListItemSearchQuerySchema
    ) -> MediaFolderList.Query {
        .init(
            parentId: emptyToNil(query.filters.parentId ?? "")
        )
    }

    func map(
        _ detail: MediaFolderDetail
    ) -> Components.Schemas.MediaFolderDetailSchema {
        .init(
            id: detail.id,
            parentId: detail.parentId,
            name: detail.name,
            path: detail.path,
            assetCount: detail.assetCount,
            totalSizeBytes: detail.totalSizeBytes,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ item: MediaFolderList.Item
    ) -> Components.Schemas.MediaFolderListItemSchema {
        .init(
            id: item.id,
            parentId: item.parentId,
            name: item.name,
            path: item.path,
            assetCount: item.assetCount,
            totalSizeBytes: item.totalSizeBytes,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ query: Components.Schemas.MediaProcessorListItemSearchQuerySchema
    ) -> MediaProcessorList.Query {
        let sort: [MediaProcessorList.Query.Sort] = (query.sort ?? [])
            .map { rule in
                let field: MediaProcessorList.Query.Sort.Field
                switch rule.field {
                case .id: field = .id
                case .name: field = .name
                case .matchExtensions: field = .matchExtensions
                case .commandTemplate: field = .commandTemplate
                case .isRequired: field = .isRequired
                case .isActive: field = .isActive
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return MediaProcessorList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: MediaProcessorDetail
    ) -> Components.Schemas.MediaProcessorDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            matchExtensions: detail.matchExtensions,
            commandTemplate: detail.commandTemplate,
            isRequired: detail.isRequired,
            isActive: detail.isActive,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ item: MediaProcessorList.Item
    ) -> Components.Schemas.MediaProcessorListItemSchema {
        .init(
            id: item.id,
            name: item.name,
            matchExtensions: item.matchExtensions,
            commandTemplate: item.commandTemplate,
            isRequired: item.isRequired,
            isActive: item.isActive
        )
    }
}

extension Array {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)

        for item in self {
            let value = try await transform(item)
            result.append(value)
        }
        return result
    }
}
