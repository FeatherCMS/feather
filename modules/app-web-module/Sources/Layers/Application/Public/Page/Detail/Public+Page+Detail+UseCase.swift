public import FeatherApplication
public import FeatherModuleKit
import Foundation
import WebDomain
import WebModule

extension Public.Page.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(query: any QueryExecutor<Scope>) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            let now = Date()
            return try await query.run { scope in
                let page = try await scope.page.find(id: input.id)
                guard
                    page.metadata.status == .draft
                        || Metadata.Model.Availability(
                            status: page.metadata.status,
                            publicationDate: page.metadata.publicationDate,
                            expirationDate: page.metadata.expirationDate,
                            at: now
                        ) == .live
                else {
                    throw Error(message: "Page not found")
                }
                return .init(
                    id: page.id,
                    title: page.title,
                    excerpt: page.excerpt,
                    content: page.content,
                    imageAssetId: page.imageAssetId,
                    imageURL: "",
                    media: nil,
                    metadata: page.metadata.asSnapshot
                )
            }
        }
    }
}
