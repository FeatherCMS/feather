import FeatherAdmin
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Job.List.Repository {
    struct OpenAPI: WebAdmin.System.Job.List.Repository.Interface {
        let api: SystemAdminAPIClient

        func list() async throws -> [Components.Schemas.SystemJobSchema] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                var jobs: [Components.Schemas.SystemJobSchema] = []
                var pageNumber = 1

                while true {
                    let response = try await client.systemJobList(
                        query: .init(pageSize: 100, pageNumber: pageNumber),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                    let page: [Components.Schemas.SystemJobSchema]
                    switch response {
                    case .ok(let value):
                        page = try value.body.json
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

                    jobs.append(contentsOf: page)
                    guard page.count == 100 else { break }
                    guard pageNumber < Int.max else { break }
                    pageNumber += 1
                }

                return jobs
            }
        }
    }
}
