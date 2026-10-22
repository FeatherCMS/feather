import AccountApplication
import AccountModule
import Foundation

extension Invitation.Table.Detail {
    func asDetail() throws -> Invitation.Detail.Output {
        .init(
            id: id,
            userId: userId,
            email: email,
            token: token,
            roleIDs: try JSONDecoder()
                .decode([String].self, from: Data(roleIds.utf8)),
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Invitation.Table.List {
    func asListItem() throws -> Invitation.List.Output.Item {
        .init(
            id: id,
            userId: userId,
            email: email,
            token: token,
            roleIDs: try JSONDecoder()
                .decode([String].self, from: Data(roleIds.utf8)),
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    func asSearchItem() throws -> Invitation.Search.Output.Item {
        .init(
            id: id,
            userId: userId,
            email: email,
            token: token,
            roleIDs: try JSONDecoder()
                .decode([String].self, from: Data(roleIds.utf8)),
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
