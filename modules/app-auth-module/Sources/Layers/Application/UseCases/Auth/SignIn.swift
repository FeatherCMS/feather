//
//  SignIn.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import UserDomain
import UserModule

import struct Foundation.Date

protocol SignIn: UseCase {

    func makeAuthResponse(
        authorization: any Identity.Authorization.Query.Interface,
        userSessionRepository: any SessionRepository,
        user: Identity.Model,
        authenticationType: String,
        authenticationReference: String,
        isPersistent: Bool
    ) async throws -> AuthDetail

}

extension SignIn {

    func makeAuthResponse(
        authorization: any Identity.Authorization.Query.Interface,
        userSessionRepository: any SessionRepository,
        user: Identity.Model,
        authenticationType: String,
        authenticationReference: String,
        isPersistent: Bool
    ) async throws -> AuthDetail {
        let identityId = user.id

        let (roles, permissions) = try await (
            authorization.getRolesBy(identityId: identityId),
            authorization.getPermissionsBy(identityId: identityId)
        )

        let sessionLifetime =
            isPersistent
            ? Session.Lifetimes.persistent : Session.Lifetimes.regular

        let session = try await userSessionRepository.insert(
            Session.create(
                token: generateToken(),
                identityId: identityId,
                authenticationType: authenticationType,
                authenticationReference: authenticationReference,
                expiresAtInterval: sessionLifetime,
                isPersistent: isPersistent
            )
        )

        return .init(
            user: user,
            session: session,
            roles: roles,
            permissions: permissions
        )
    }
}
