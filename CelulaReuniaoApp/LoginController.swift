//
//  ViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 17/07/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var usuarios : [NSManagedObject] = []
    var nomeUsu : String = ""
    var databaseHand : DatabaseHandle?
    var tipoOperacao : String? //Se é login ou logout


    
//    var txtBemVindo : String = ""
    var txtCelula1 : String = ""
    var txtEndereco1 : String = ""
    var txtDia1 : String = ""
    var txtAnfitriao1 : String = ""
    var txtHorario1 : String = ""
    var txtIdCelula1 : String = ""
    var temCelula : String?
    
    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtSenha: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        let logado = VerificaUsuarioLogado()
        if logado == "logado" {
            let autenticacao = Auth.auth()
            autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
                if let usuarioLogado = usuario {
                    let usuarioSelecionado = usuarioLogado.uid
                    //verifica se usuario tem celula
                    let database  = Database.database().reference()
                    let usuario = database.child("usuarios").queryOrderedByKey().queryEqual(toValue: usuarioSelecionado)
                
                    usuario.observe(DataEventType.childAdded, with: { (usuSnap) in
                    let temCelula = usuSnap.value as! NSDictionary
                    
                    if temCelula["temCelula"] as! String == "N" {
                        let tCelula = "N"
                        self.performSegue(withIdentifier: "homeSegue", sender: tCelula)
                    }else {
                        let tCelula = "S"
                        self.performSegue(withIdentifier: "homeSegue", sender: tCelula)
                        }
                    })

//                let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioSelecionado)
//
//                celula.observe(DataEventType.childAdded, with: {(celulaRecuperada) in
//                    let dados = celulaRecuperada.value as! NSDictionary
//
//
//                    self.txtCelula1 = dados["lider"] as! String
//                    self.txtAnfitriao1 = dados["anfitriao"] as! String
//                    self.txtEndereco1 = dados["endereco"]  as! String
//                    self.txtDia1 = dados["dia"] as! String
//                    self.txtAnfitriao1 = dados["anfitriao"] as! String
//                    self.txtHorario1 = dados["horario"] as! String
//                   // self.txtIdCelula1 = dados["idCelula"] as! String
//
//                    if self.temCelula == "N" {//self.txtCelula1.isEmpty {
//                        self.performSegue(withIdentifier: "homeSegue", sender: nil)
//                    }else {
//                        self.performSegue(withIdentifier: "homeSegue", sender: nil)
//                    }
//                })
               }
            }
        }
    }
    
    func VerificaUsuarioLogado () -> String {
        var logado : String = ""
        
        let autenticacao = Auth.auth()
        
        if let usuariologado = autenticacao.currentUser?.uid {
            logado = "logado"
        }
        else {
            logado = "desconectado"
        }
        return logado
    }
    
    
    @IBAction func esconderTeclado(_ sender: Any) {
        self.resignFirstResponder()
        
    }
    @IBAction func esconderTecladoSenha(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
//    //coreData
//    @IBAction func logar_usuario(_ sender: Any) {
//
//        let login : String = txtUsuario.text!
//        let senha : String = txtSenha.text!
//
//        if !login.isEmpty && !senha.isEmpty {
//                logar()
//        } else {exibeMensagemAlerta(titulo: "Dados Incorretos", mensagem: "Verifique os dados digitados e tente novamente.")}
//    }
    

    //Firebase // Logar Verdadeiro
    @IBAction func logarFirebase(_ sender: Any) {
        if let emailR = txtUsuario.text {
            if let senhaR = txtSenha.text {
                
                //Autenticar usuario
                let autenticacao = Auth.auth()
                autenticacao.signIn(withEmail: emailR, password: senhaR) { (usuario, erro) in
                    
                    if erro == nil {
                        if usuario == nil {
                            self.exibeMensagemAlerta(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticação. Tente novamente.")
                        }else {
                                   //self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                            let database  = Database.database().reference()
                            let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuario?.user.uid)

                            self.databaseHand = celula.observe(DataEventType.value, with: { (celulaRecuperada) in
                                if let dados = celulaRecuperada.value as? NSDictionary {
                                   
                                    if let celula = dados["lider"]  {
                                        self.txtCelula1 = celula as! String
                                        
                                    }
                                    if let anfitriao = dados["anfitriao"] {
                                        self.txtAnfitriao1 = anfitriao as! String
                                    }
                                    if let endereco = dados["endereco"] {
                                       self.txtEndereco1 = endereco as! String
                                    }
                                    if let dia = dados["dia"] {
                                        self.txtDia1 = dia as! String
                                    }
                                    if let horario = dados["horario"] {
                                        self.txtHorario1 = horario as! String
                                    }
                                    if let idCelula = dados["idCelula"] {
                                        self.txtIdCelula1 = idCelula as! String
                                    }
                                    
                                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
                                    
                                } else {
                                
                                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
                                }
                            }, withCancel: { (erro) in
                                print ("####### deu ruim ######")
                            })
                        }
                    }else {
                       self.exibeMensagemAlerta(titulo: "Dados Incorretos", mensagem: "Verifique os dados digitados e tente novamente.")
                    }
                }
            }
        }
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destino = segue.destination as! HomeViewController
            if self.txtCelula1 != nil {
                destino.nomeLider = self.txtCelula1
            }
        }
        
    }
    
//    func logar () {
//        var usuarioValido : Bool = false
//        let requisicao = NSFetchRequest <NSFetchRequestResult>(entityName: "Usuarios")
//
//        do {
//            let usuariosRecuperados = try context.fetch(requisicao)
//            self.usuarios = usuariosRecuperados as! [NSManagedObject]
//                        if usuarios.count > 0 {
//                            for usuario in usuarios {
//
//                                let login = usuario.value(forKey: "login") as! String
//                                let senha = usuario.value(forKey: "senha") as! String
//
//                                if login == txtUsuario.text && senha == txtSenha.text {
//                                    nomeUsu = usuario.value(forKey: "nome") as! String
//                                    usuarioValido = true
//                                    break
//                                }
//                                else {
//                                    exibeMensagemAlerta(titulo: "Autenticação", mensagem: "Usuario ou senha invalidos")
//                                }
//                            }
//                        }else {
//                            exibeMensagemAlerta(titulo: "Autenticação", mensagem: "Usuario ou senha invalidos")
//                        }
//            if usuarioValido {
//                self.performSegue(withIdentifier: "HomeSegue", sender: nil)
//            }
//        } catch  {
//            print ("Erro ao recuperar dados")
//        }
//
//    }


    func Deslogar () {
        
        let autenticacao = Auth.auth()
        
        do {
            try autenticacao.signOut()
            
            //redireciona para tela de login
            //self.performSegue(withIdentifier: "voltaParaLogin", sender: nil)
            
        } catch  {
            print ("Erro ao Deslogar.")
        }
    }
    
}

