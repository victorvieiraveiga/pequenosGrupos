//
//  HomeViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 30/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblBoasVindas: UILabel!
    var nomeLider : String?
    var idCelula : String?
    
    
    @IBOutlet var homeView: UIView!
    
    
    @IBAction func deslogar(_ sender: Any) {
        
        let usuario = VerificaUsuarioLogado()
        
        if usuario == "logado" {
            do {
                let autenticacao = Auth.auth()
                try autenticacao.signOut()
                //redireciona para tela de login
                self.performSegue(withIdentifier: "voltaParaLogin", sender: nil)
                } catch  {
                    print ("Erro ao Deslogar.")
                }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(tap))
        touch.numberOfTapsRequired = 1
        homeView.addGestureRecognizer(touch)
        
        //Menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //if self.nomeLider != nil {
                let autenticacao = Auth.auth()
            
                autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
                    if let usuarioLogado = usuario {
                        let usuarioSelecionado = usuarioLogado.uid
                        //verifica se usuario tem celula
                        let database  = Database.database().reference()
                        
                        let usuario = database.child("usuarios").queryOrderedByKey().queryEqual(toValue: usuarioSelecionado)
                        
                        usuario.observe(DataEventType.childAdded, with: { (usuSnap) in
                            let usuarios = usuSnap.value as! NSDictionary
                            let nomeUsuario = usuarios["nome"] as! String
                            
                            if usuarios["temCelula"] as! String == "N" {
                                self.carregaInfoTela(nome: "Olá " + nomeUsuario , boasVindas: "Toque AQUI para configurar seu pequeno Grupo.")
                            }else {
                                self.carregaInfoTela(nome: "Olá " + nomeUsuario , boasVindas: "Seja Bem Vindo")
                            }
                        })
                    }
                    else {
                        print ("nao logado")
                        self.carregaInfoTela(nome: "Olá" , boasVindas: "Toque no menu Login para iniciar.")
                    }
                    
                }
      //  } else {

      //      carregaInfoTela(nome: "Visitante", boasVindas: "Olá, você precisa efetuar o login para continuar")
       // }

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
    
    func carregaInfoTela (nome: String, boasVindas : String) {
        //let lblNome = UILabel()
        //let lblBoasVindas = UILabel()
        
        self.lblNome.text = nome
        self.lblBoasVindas.text = boasVindas
    }
    
    @objc func tap(){
        if self.lblBoasVindas.text == "Toque AQUI para configurar seu pequeno Grupo." {
        self.performSegue(withIdentifier: "configuraCelula", sender: nil)
        }else {
            print ("nao faz nada")
        }
        
    }
    
    
}

