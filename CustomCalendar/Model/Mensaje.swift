//
//  Mensaje.swift
//  CustomCalendar
//
//  Created by Eric Martin Galan on 4/9/21.
//

import Foundation

struct Mensaje: Codable {
    
    var texto: String!
    var fecha: String!
    var uid: String!
    
    init(texto:String, fecha:String, uid:String) {
        self.fecha = fecha
        self.texto = texto
        self.uid = uid
    }
    init(){
    }
}
