//
//  LogRepository.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol LogRepository: Repository {

    func insert(
        _ model: Log.New
    ) async throws -> Log
}
