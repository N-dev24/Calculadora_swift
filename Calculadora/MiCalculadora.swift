//
//  MiCalculadora.swift
//  Calculadora
//
//  Created by MAC on 20/11/26.
//

import SwiftUI


struct MiCalculadora: View {
    @State private var pantalla = ""
    @State private var numero1 = 0.0
    @State private var operacion = ""
    @State private var operacionTexto = ""

    let filas = [
        ["C", "/", "*", "-"],
        ["7", "8", "9", "+"],
        ["4", "5", "6", "="],
        ["1", "2", "3", "."],
        ["0"]
    ]

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Text(operacionTexto)
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 30, alignment: .trailing)

            Text(pantalla.isEmpty ? "0" : pantalla)
                .font(.system(size: 64, weight: .light))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .frame(maxWidth: .infinity, alignment: .trailing)

            ForEach(filas, id: \.self) { fila in
                HStack(spacing: 12) {
                    ForEach(fila, id: \.self) { tecla in
                        BotonCalc(tecla: tecla) {
                            tocar(tecla)
                        }
                    }
                }
            }
        }
        .padding()
    }

    func tocar(_ tecla: String) {
        switch tecla {
        case "C":
            clicBorrar()
        case "=":
            clicIgual()
        case "+", "-", "*", "/":
            clicOperacion(tecla)
        default:
            clicNumero(tecla)
        }
    }

    func clicOperacion(_ op: String) {
        guard let numero = Double(pantalla) else { return }

        numero1 = numero
        operacion = op
        operacionTexto = pantalla + " " + op
        pantalla = ""
    }

    func clicIgual() {
        guard let numero2 = Double(pantalla),
              !operacion.isEmpty else { return }

        var resultado = 0.0

        switch operacion {
        case "+":
            resultado = numero1 + numero2
        case "-":
            resultado = numero1 - numero2
        case "*":
            resultado = numero1 * numero2
        case "/":
            guard numero2 != 0 else {
                pantalla = "Error"
                return
            }
            resultado = numero1 / numero2
        default:
            break
        }

        pantalla = String(resultado)
        operacionTexto = ""
        operacion = ""
    }

    func clicBorrar() {
        pantalla = ""
        operacionTexto = ""
        numero1 = 0
        operacion = ""
    }

    func clicNumero(_ digito: String) {
        pantalla += digito
    }
}

struct BotonCalc: View {
    let tecla: String
    let accion: () -> Void

    var esNumero: Bool {
        Int(tecla) != nil || tecla == "."
    }

    var colorFondo: Color {
        if esNumero {
            return .gray.opacity(0.2)
        } else if tecla == "C" {
            return .red
        } else {
            return .orange
        }
    }

    var body: some View {
        Button(action: accion) {
            Text(tecla)
                .font(.title)
                .frame(maxWidth: .infinity, minHeight: 70)
                .background(colorFondo)
                .foregroundStyle(esNumero ? Color.primary : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    MiCalculadora()
}
