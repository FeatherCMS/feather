//
//  InvitationRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AccountModule
public import FeatherDomain

extension Invitation {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func findBy(id: String) async throws -> Invitation.Model?

            func findBy(token: String) async throws -> Invitation.Model?

            func insert(_ model: Invitation.Model.New) async throws
                -> Invitation.Model

            func update(_ model: Invitation.Model) async throws
                -> Invitation.Model

            func delete(ids: [String]) async throws -> [String]
        }
    }
}
