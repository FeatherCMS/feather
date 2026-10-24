import FeatherDatabase
public import WebAppAPI
import WebApplication
import WebModule

extension AppAPIGateway {
    public func metadataGet(
        _ input: Operations.MetadataGet.Input
    ) async throws -> Operations.MetadataGet.Output {
        guard let metadata = try await resolveMetadata(slug: input.path.slug)
        else {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Page not found",
                                reason:
                                    "No published page exists for this route."
                            )
                        )
                    )
                )
            )
        }
        return .ok(.init(body: .json(metadata)))
    }

    public func metadataRootGet(
        _ input: Operations.MetadataRootGet.Input
    ) async throws -> Operations.MetadataRootGet.Output {
        guard let metadata = try await resolveMetadata(slug: "") else {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Page not found",
                                reason:
                                    "No published page exists for this route."
                            )
                        )
                    )
                )
            )
        }
        return .ok(.init(body: .json(metadata)))
    }

    private func resolveMetadata(
        slug: String
    ) async throws -> Components.Schemas.MetadataSchema? {
        do {
            let route = try await useCases.makeResolveWebRoute()
                .execute(input: WebRoute.Resolve.Input(slug: slug))
            return .init(
                referenceType: route.referenceType,
                referenceId: route.referenceID,
                slug: route.slug,
                template: route.template
            )
        }
        catch is WebRoute.Resolve.UseCase.Error {
            return nil
        }
        catch let error as DatabaseError where error.isResolveWebRouteNotFound {
            return nil
        }
    }
}
