//
//  CadastroUsuarioViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 06/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class CadastroUsuarioViewController: UIViewController {

    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSenha: UITextField!
    
    
    @IBAction func CriarConta(_ sender: Any) {
        
        if let nomeR = txtNome.text {
            if let emailR = txtEmail.text {
                if let senhaR = txtSenha.text {
                    //Criar conta no firebase
                    
                    if nomeR != "" {
                    
                    
                    let autenticacao = Auth.auth()
                   
                    autenticacao.createUser(withEmail: emailR, password: senhaR) { (usuario, erro) in
                        
                        if erro == nil {
                            if usuario == nil {
                                self.exibeMensagemAlerta(titulo: "Erro.", mensagem: "Erro ao autenticar. Tente novamente.")
                            }else {
                                //inicio - salva usuarios no banco de dados do firebase
                                let database = Database.database().reference()
                                let usuarios = database.child("usuarios")
                                let usuarioDados = ["nome" : nomeR, "email" : emailR, "temCelula" : "N"]
                                usuarios.child(usuario!.user.uid).setValue(usuarioDados)
                                //fim - salva usuarios no banco de dados do firebase
                                
                                //redireciona para tela principal
                                 self.performSegue(withIdentifier: "CadastroLoginSegue", sender: nil)
                            }
                            self.exibeMensagemAlerta(titulo: "Sucesso.", mensagem: "Usuario cadastrado")
                        } else {
                            
                            
                            
                            let erroR = erro! as NSError
                            //print (erroR.userInfo["error_name"])
                           
                            
                            if let codigoErro = erroR.localizedDescription as? String {
                                //let erroTexto = codigoErro as! String
                                var mensagemErro = ""
                                
                                switch codigoErro {
                                    case "The email address is badly formatted." :
                                        mensagemErro = "Email Invalido. Digite um email valido."
                                        break
                                    case "The password must be 6 characters long or more." :
                                        mensagemErro = "A Senha precisa ter no minimo 6 caracteres com letras e numeros."
                                        break
                                    case "The email address is already in use by another account." :
                                        mensagemErro = "Esse email já esta sendo utilizado, use outro email para criar a conta."
                                        break
                                    
                                default:
                                    mensagemErro = "Os Dados digitados estão incorretos."
                                }
                                 self.exibeMensagemAlerta(titulo: "Erro", mensagem: mensagemErro)
                            }
                        }
                    }
                    }else {
                        self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Digite seu Nome para prosseguir.")
                    }
                } else {
                    self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Dados invalidos.")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func esconde_nome(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func escon_email(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func esconde_senha(_ sender: Any) {
        self.resignFirstResponder()
    }
    
}
