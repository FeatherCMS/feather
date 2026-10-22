public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit
import Foundation
import MediaDomain
public import MediaModule

extension Asset.Folder.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Asset.Folder.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Asset.Folder.Edit.Scope>
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
            return try await transaction.run { scope in
                guard var folder = try await scope.folders.find(id: input.id)
                else {
                    throw Asset.Folder.Edit.Error.notFound
                }
                let name = input.name.apply(to: folder.name).whitespaceTrimmed
                let slug = normalizedSlug(name)
                guard !name.isEmpty, !slug.isEmpty else {
                    throw Asset.Folder.Edit.Error.invalidName
                }
                let parentPath: String?
                if let parentId = folder.parentId {
                    parentPath = try await scope.folders.find(id: parentId)?
                        .slugPath
                }
                else {
                    parentPath = nil
                }
                let slugPath = parentPath.map { "\($0)/\(slug)" } ?? slug
                if slugPath != folder.slugPath,
                    try await scope.folders.find(slugPath: slugPath) != nil
                {
                    throw Asset.Folder.Edit.Error.duplicatePath
                }
                folder.name = name
                folder.slug = slug
                folder.slugPath = slugPath
                let updated = try await scope.folders.update(folder)
                return .init(detail: updated.asDetail)
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
