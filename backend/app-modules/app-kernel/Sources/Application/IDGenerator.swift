//
//  IDGenerator.swift
//  app-kernel
//
//  Created by Binary Birds on 2026. 06. 18.

public protocol IDGenerator: Sendable {
    func generate() -> String
}
