import AdminOpenAPI

struct AdminAddNewsletterSubscriberOpenAPIRepository {
    let api: AdminAPI

    func listCampaigns() async throws
        -> [AdminNewsletterSubscriberCampaignOption]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterList()
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(id: $0.id, name: $0.name)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view campaigns."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view campaigns."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func create(
        form: AdminAddNewsletterSubscriberForm,
        campaigns: [AdminNewsletterSubscriberCampaignOption]
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            for campaign in campaigns
            where form.selectedCampaignIds.contains(campaign.id) {
                let response =
                    try await client.contactNewsletterSubscriberCreate(
                        path: .init(contactNewsletterId: campaign.id),
                        body: .json(
                            .init(
                                email: form.email,
                                firstName: form.firstName,
                                lastName: form.lastName,
                                status: "subscribed"
                            )
                        )
                    )
                switch response {
                case .created: continue
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized(
                        message: "Please sign in again to add subscribers."
                    )
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden(
                        message: "Your account cannot add subscribers."
                    )
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
