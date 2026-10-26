import FeatherWebAdmin
import FeatherWebShared
import Foundation
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime

extension Campaign.Subscriber.Import.Repository {
    struct OpenAPI: Interface {
        private struct EmailPage {
            let emails: Set<String>
            let total: Int
        }

        let api: API.Client

        func existingEmails(newsletterId: String) async throws -> Set<String> {
            let pageSize = 100
            var page = 1
            var emails: Set<String> = []
            var total = 0

            repeat {
                let currentPage = page
                let pageResult =
                    try await api
                    .withOpenAPIRepositoryErrorMapping { client in
                        let response =
                            try await client.newsletterSubscriberQuery(
                                body: .json(
                                    .init(
                                        page: .init(
                                            size: pageSize,
                                            number: currentPage
                                        ),
                                        sort: [
                                            .init(
                                                field: .email,
                                                direction: .asc
                                            )
                                        ],
                                        filters: .init(
                                            search: nil,
                                            campaignKey: newsletterId,
                                            email: nil
                                        )
                                    )
                                )
                            )
                        switch response {
                        case .ok(let value):
                            let result = try value.body.json
                            let emails = Set(
                                result.data.items
                                    .filter { item in
                                        item.memberships.contains {
                                            $0.campaignKey == newsletterId
                                        }
                                    }
                                    .map { $0.email.lowercased() }
                            )
                            return EmailPage(
                                emails: emails,
                                total: result.data.total
                            )
                        case .unauthorized:
                            throw OpenAPIRepositoryError.unauthorized
                        case .forbidden:
                            throw OpenAPIRepositoryError.forbidden
                        case .undocumented(let statusCode, let response):
                            throw try await api.failure(
                                statusCode: statusCode,
                                responseBody: response.body
                            )
                        }
                    }
                emails.formUnion(pageResult.emails)
                total = pageResult.total
                page += 1
            } while (page - 1) * pageSize < total

            return emails
        }

        func create(
            newsletterId: String,
            record: Campaign.Subscriber.Import.CSVParser.Record
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterSubscriberCreate(
                    path: .init(newsletterCampaignKey: newsletterId),
                    body: .json(
                        .init(
                            email: record.email,
                            firstName: record.firstName.isEmpty
                                ? nil : record.firstName,
                            lastName: record.lastName.isEmpty
                                ? nil : record.lastName,
                            status: record.status ?? "subscribed"
                        )
                    )
                )
                switch response {
                case .created: return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }
    }
}
