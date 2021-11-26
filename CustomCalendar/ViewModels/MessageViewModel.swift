//
//  MessageViewModel.swift
//  CustomCalendar
//
//  Created by Eric Martin Galan on 4/9/21.
//

import Foundation
import FirebaseDatabase
import Firebase

class MessageViewModel: ObservableObject{
    
    @Published var messages = [Mensaje]()
    
    var ref: DatabaseReference!
    
    func addMessage (texto:String, fecha:String){
        ref = Database.database().reference()
        let docMessage: [String: Any] = [
                "texto": texto as Any,
                "fecha": fecha as Any,
        ]
        self.ref.child("mensajes").childByAutoId().child("mensaje").setValue(docMessage)
    }
    
    func readMessage(completion: @escaping () -> ()) -> Void {
        ref = Database.database().reference()
        ref.child("mensajes").observe(DataEventType.value, with: { snapshot in
            if let mensajes = snapshot.value as? Dictionary <String,AnyObject>{
                for (key,value) in mensajes {
                    if let dict = value as? Dictionary <String,AnyObject>{
                        if let mensajeLeido = dict["mensaje"] as? Dictionary <String,AnyObject>{
                            if let texto = mensajeLeido["texto"] as? String, let fecha = mensajeLeido["fecha"] as? String{
                                let uid = key
                                let mensaje = Mensaje (texto: texto, fecha: fecha, uid: uid)
                                self.messages.append(mensaje)
                            }
                        }
                    }
                }
            }
            completion()
        })

//        ref.child("mensajes").getData { (error, snapshot) in
//            if let error = error {
//                print("Error getting data \(error)")
//                completion()
//            }
//            else if snapshot.exists() {
//                if let mensajes = snapshot.value as? Dictionary <String,AnyObject>{
//                    for (key,value) in mensajes {
//                        if let dict = value as? Dictionary <String,AnyObject>{
//                            if let mensajeLeido = dict["mensaje"] as? Dictionary <String,AnyObject>{
//                                if let texto = mensajeLeido["texto"] as? String, let fecha = mensajeLeido["fecha"] as? String{
//                                    let uid = key
//                                    let mensaje = Mensaje (texto: texto, fecha: fecha, uid: uid)
//                                    self.messages.append(mensaje)
//                                }
//                            }
//                        }
//                    }
//                }
//                completion()
//            }
//            else {
//                print("No data available")
//                completion()
//            }
//        }
    }
}
