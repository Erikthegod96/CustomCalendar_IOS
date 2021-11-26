//
//  ContentView.swift
//  CustomCalendar
//
//  Created by Eric Martin Galan on 4/9/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var messages = MessageViewModel()
    let userCalendar = Calendar.current
    @State var sysdate = Date()
    @State var sysdateToString : String = ""
    @State var fechaHoy: String = ""
    @State var dia: String = ""
    @State var numero: String = ""
    @State var mes: String = ""
    @State var messageDay: Mensaje
    @State var currentDate = Date()
    @State var textoIntroducido = ""
    @State var showingAlert = false

    var body: some View {
            VStack{
                VStack{
                    Text(mes).foregroundColor(.white).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.system(size: 40)).padding()
                    Text(dia).foregroundColor(.white).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.system(size: 30)).padding()
                }
                Spacer()
                HStack{
                    Button(action: {
                        restarDia()
                    }, label: {
                        Text("<")
                    }).buttonStyle(CircleStyle()).frame(width: 40, height: 40)
                    .foregroundColor(.white).padding()
                    Spacer()
                    Text(numero).foregroundColor(.white).fontWeight(.bold).font(.system(size: 90)).padding()
                    Spacer()
                    Button(action: {
                        sumarDia()
                    }, label: {
                        Text(">")
                    }).buttonStyle(CircleStyle()).frame(width: 40, height: 40)
                    .foregroundColor(.white).padding()
                }
                Spacer()
                if(messageDay.texto != nil){
                    Text(messageDay.texto).foregroundColor(.white).fontWeight(.bold).multilineTextAlignment(.center).font(.system(size: 16)).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).padding()
                } else if (userCalendar.compare(currentDate, to: sysdate, toGranularity: .day) == .orderedDescending){
                    Text("No vayas tan rápido").foregroundColor(.white).fontWeight(.bold).font(.system(size: 20)).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                }else {
                    Text("Vaya, aun no tienes ningún mensaje").foregroundColor(.white).fontWeight(.bold).font(.system(size: 20)).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                    TextField("Introduce aqui tu mensaje", text: $textoIntroducido).font(.system(size: 20))
                        .multilineTextAlignment(.center)
                        .padding(2)
                        .background(Color.white)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        .padding()
                    Button(action: {
                        if(textoIntroducido == ""){
                            showingAlert = true
                        } else{
                            addMessage()
                        }
                    }){
                        Text("Confirmar")
                    }.alert(isPresented: $showingAlert){
                        Alert(title: Text("Error al añadir el mensaje, está vacio"), message: Text("Error"), dismissButton: .default(Text("OK")){
                        })
                    }.foregroundColor(.white).padding()
                }
                Spacer()
            }.background(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all))
            .onAppear(){
                    cargaFecha()
                    readMessage()
            }
    }
    
    func cargaFecha(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "es_ES") as Locale
        dateFormatter.dateFormat = "dd-MM-yyyy"
        fechaHoy = dateFormatter.string(from: currentDate)
        dateFormatter.dateFormat = "dd"
        numero = dateFormatter.string(from: currentDate)
        dateFormatter.dateFormat = "EEEE"
        dia = dateFormatter.string(from: currentDate).uppercased()
        dateFormatter.dateFormat = "MMMM"
        mes = dateFormatter.string(from: currentDate).uppercased()
    }
    
    func restarDia(){
        var dayComponent    = DateComponents()
        dayComponent.day    = -1 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let lastDate        = theCalendar.date(byAdding: dayComponent, to: currentDate)
        currentDate = lastDate!
        cargaFecha()
        self.messageDay = Mensaje()
        for message in self.messages.messages {
            if(message.fecha == self.fechaHoy){
                self.messageDay = message
            }
        }
    }
    
    func sumarDia(){
        var dayComponent    = DateComponents()
        dayComponent.day    = 1 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let lastDate        = theCalendar.date(byAdding: dayComponent, to: currentDate)
        currentDate = lastDate!
        cargaFecha()
        self.messageDay = Mensaje()
        for message in self.messages.messages {
            if(message.fecha == self.fechaHoy){
                self.messageDay = message
            }
        }
    }
    
    func readMessage() {
        self.messages.readMessage(completion:{
            for message in self.messages.messages {
                if(message.fecha == self.fechaHoy){
                    self.messageDay = message
                }
            }
        })
    }
    
    func addMessage(){
        self.messages.addMessage(texto: self.textoIntroducido,fecha: self.fechaHoy)
        let messageNew = Mensaje(texto: self.textoIntroducido, fecha: self.fechaHoy, uid: "")
        self.messages.messages.append(messageNew)
        self.messageDay = messageNew
    }
    
}

struct CircleStyle: ButtonStyle {
    @State var press : Bool = false
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        Circle()
            .fill()
            .overlay(Circle().fill(Color.blue).opacity(press ? 0.3 : 0))
            .overlay(Circle().stroke(lineWidth: 2).foregroundColor(.blue).padding(1))
            .overlay(configuration.label.foregroundColor(.blue))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(messages: MessageViewModel(), fechaHoy: "",dia: "",mes: "",messageDay: Mensaje(texto: "", fecha: "", uid: ""))
    }
}
