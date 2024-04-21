//
//  MessagesController.swift
//
//
//  Created by Ildar Shamsullin on 20.02.2024.
//

import Vapor
import Fluent

struct MessagesController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let messagesRoute = routes.grouped("api", "messages")
        
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        
        let tokenAuthGroup = messagesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        tokenAuthGroup.on(.POST, "create", body: .collect(maxSize: "50mb"), use: createHandler)
    }
    
    func createHandler(req: Request) async throws -> Message.Public {
        let user = try req.auth.require(User.self)
        
        let createData = try req.content.decode(MessageCreateRequest.self)
        
        guard let thread = try await Thread.find(createData.threadId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let message = try Message(
            content: createData.content,
            thread: thread,
            user: user)
        try await message.save(on: req.db)
        
        try await attachRepliesToMessage(message, on: req)
        
        if let files = createData.files {
            let filesInfo = try await FilesController.writeFilesToDisk(files, 
                                                                       req: req)
            try await FilesController.saveFilesToDatabase(filesInfo, message: message, req: req)
        }
        
        try await message.$repliesTo.load(on: req.db)
        try await message.$repliesBy.load(on: req.db)
        try await message.$photo.load(on: req.db)
        try await message.$user.load(on: req.db)
        
        return try message.asPublic()
    }
    
    private func attachRepliesToMessage(_ message: Message, on req: Request) async throws {
        let messagesIds = parseMessagesIdsFromContent(message.content)

        let threadId = message.$thread.id

        for messageId in messagesIds {
            guard let repliedToMessage = try await Message.query(on: req.db)
                .group(.and, {
                    $0.filter(\.$id == messageId)
                    $0.filter(\.$thread.$id == threadId)
                })
                .first()
            else {
                continue
            }
            
            if try await !message.$repliesTo.isAttached(to: repliedToMessage, on: req.db) {
                try await message.$repliesTo.attach(repliedToMessage,
                                                    on: req.db)
            }
        }
    }
    
    private func parseMessagesIdsFromContent(_ content: String) -> [Int] {
        let result = content.matches(of: #/\b>>(?<messageId>\d+)\b/#)
        return result.compactMap { Int($0.output.messageId) }
    }
}
