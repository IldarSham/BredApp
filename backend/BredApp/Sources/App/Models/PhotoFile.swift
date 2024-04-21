//
//  PhotoFile.swift
//
//
//  Created by Ildar Shamsullin on 29.02.2024.
//

import Fluent
import Vapor

final class PhotoFile: Model {
    
    static var schema = "photo-files"
    
    struct Public: Content {
        let url: String
        let width: Int
        let height: Int
        let fileSize: Int
    }
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "path")
    var path: String
    
    @Field(key: "width")
    var width: Int
    
    @Field(key: "height")
    var height: Int
    
    @Field(key: "file_size")
    var fileSize: Int
    
    @Parent(key: "message_id")
    var message: Message
    
    init() { }
    
    init(id: Int? = nil, path: String, width: Int, height: Int, fileSize: Int, message: Message) throws {
        self.id = id
        self.path = path
        self.width = width
        self.height = height
        self.fileSize = fileSize
        self.$message.id = try message.requireID()
    }
}

extension PhotoFile {
    
    func asPublic() -> PhotoFile.Public {
        return PhotoFile.Public(url: "\(ServerConfig.baseURL)/\(self.path)",
                                width: self.width,
                                height: self.height,
                                fileSize: self.fileSize)
    }
}
