public import FeatherApplication
public import FeatherModuleKit
import Foundation
import MediaDomain
public import MediaModule

extension Asset.Folder.Add {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Asset.Folder.Add.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Asset.Folder.Add.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(subject: Subject, input: Input) async throws
            -> Output
        {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let name = input.name.whitespaceTrimmed
            let slug = normalizedSlug(name)
            guard !name.isEmpty, !slug.isEmpty else {
                throw Asset.Folder.Add.Error.invalidName
            }
            return try await transaction.run { scope in
                let parent: Asset.Folder.Model?
                if let parentId = input.parentId {
                    parent = try await scope.folders.find(id: parentId)
                    if parent == nil {
                        throw Asset.Folder.Add.Error.parentNotFound
                    }
                }
                else {
                    parent = nil
                }
                let slugPath = parent.map { "\($0.slugPath)/\(slug)" } ?? slug
                if try await scope.folders.find(slugPath: slugPath) != nil {
                    throw Asset.Folder.Add.Error.duplicatePath
                }
                let folder = try await scope.folders
                    .insert(
                        Asset.Folder.Model.create(
                            parentId: parent?.id,
                            name: name,
                            slug: slug,
                            slugPath: slugPath
                        )
                    )
                return .init(detail: folder.asDetail)
            }
        }
    }
    }

    private func normalizedSlug(_ value: String) -> String {
    value.lowercased()
        .replacingOccurrences(
            of: "[^a-z0-9]+",
            with: "-",
            options: .regularExpression
        )
        .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
}
