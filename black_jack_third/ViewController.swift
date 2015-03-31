//
//  ViewController.swift
//  black_jack_third
//
//  Created by Alex Mathew on 3/30/15.
//  Copyright (c) 2015 Alex Mathew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet var playerCard1: UIImageView!
    @IBOutlet var playerCard2: UIImageView!
    @IBOutlet var playerCard3: UIImageView!
    @IBOutlet var playerCard4: UIImageView!
    @IBOutlet var playerCard5: UIImageView!
    @IBOutlet var playerCard6: UIImageView!
    
    
    @IBOutlet var dealerCard1: UIImageView!
    @IBOutlet var dealerCard2: UIImageView!
    @IBOutlet var dealerCard3: UIImageView!
    @IBOutlet var dealerCard4: UIImageView!
    @IBOutlet var dealerCard5: UIImageView!
    @IBOutlet var dealerCard6: UIImageView!
    
    
    @IBOutlet var computerCard1: UIImageView!
    @IBOutlet var computerCard2: UIImageView!
    @IBOutlet var computerCard3: UIImageView!
    @IBOutlet var computerCard4: UIImageView!
    @IBOutlet var computerCard5: UIImageView!
    @IBOutlet var computerCard6: UIImageView!
    
    @IBOutlet var balanceLabel: UILabel!
    
    @IBOutlet var betAmountLabel: UILabel!
    
    @IBOutlet var playerScoreLabel: UILabel!
    
    @IBOutlet var computerScoreLabel: UILabel!
    
    var playerBlackJack:Bool = false
    var balance:Int! = 100
    var betAmount:Int! = 0
    var enableHitStand:Bool = false
    var dealer = Dealer(h: Hand(), s: 0)
    var computer = Dealer(h: Hand(), s: 0)
    var player = User(h: Hand(), b: 100, s: 0)
    
    var shoe: [Card] = [Card]()


    override func viewDidLoad() {
        super.viewDidLoad()
        balanceLabel.text = "\(player.balance)"
        computerScoreLabel.text = "0"
        playerScoreLabel.text = "0"
        // Do any additional setup after loading the view, typically from a nib.
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func addBetClicked(sender: UIButton) {
        if (!enableHitStand) {
        var addedChips = sender.currentTitle!.toInt()
        if(addedChips! <= player.balance)
        {
        player.betAmount += addedChips!
        player.balance -= addedChips!
        balanceLabel.text = "\(player.balance)"
        betAmountLabel.text = "\(player.betAmount)"
            }
        }
    }
    
    
    @IBAction func placeBetClicked(sender: UIButton) {
        if(!enableHitStand) {
        enableHitStand = true
        initialSteup()
        }
    }
    
    
    
    
    func initialSteup()
    {   player.hand.cards.removeAll()
        computer.hand.cards.removeAll()
        dealer.hand.cards.removeAll()
        shoe.extend(Shoe(noOfDecks: 5).currentShoe)
        dealerPlay()
        playerPlay()
        playerPlay()
        computerPlay()
        computerPlay()
        if(player.score == 21)
        {
            var placeBetAlert = UIAlertController(title: "Congrats" ,message: "Player Hits BlackJack!!",preferredStyle:UIAlertControllerStyle.Alert)
            placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: computerLastPlay))
            presentViewController(placeBetAlert, animated: true, completion: nil)
            player.balance = player.balance + 2 * betAmount
            playerBlackJack = true
            
        }

        else if(computer.score == 21)
        {
            var placeBetAlert = UIAlertController(title: "Congrats" ,message: "Computer Hits BlackJack!!",preferredStyle:UIAlertControllerStyle.Alert)
            placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: lastDealerPlay))
            presentViewController(placeBetAlert, animated: true, completion: nil)
            
            
        }
        else if(computer.score == 21 && player.score == 21)
        {
            playerBlackJack = true
            player.balance = player.balance + 2 * betAmount
            var placeBetAlert = UIAlertController(title: "Congrats" ,message: "Computer and Human Players Hit BlackJack!!",preferredStyle:UIAlertControllerStyle.Alert)
            placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: reset))
            presentViewController(placeBetAlert, animated: true, completion: nil)
            
            
            
        }
        

        
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func dealerPlay() {
        if(!dealer.busted){
            dealer.hand.cards.append(shoe[0])
            
            dealer.score = dealer.hand.getscore()
            
            
            var handCount = dealer.hand.cards.count
            if(handCount == 0) {
               dealerCard1.image = shoe[0].cardImage
            }
            else if(handCount == 1) {
                 dealerCard2.image = shoe[0].cardImage
            }
            else if(handCount == 2) {
                dealerCard3.image = shoe[0].cardImage
            }
            else if(handCount == 3) {
                dealerCard4.image = shoe[0].cardImage
            }
            else if(handCount == 4) {
                dealerCard5.image = shoe[0].cardImage
            }
            else if(handCount == 5) {
                dealerCard6.image = shoe[0].cardImage
            }

            
            shoe.removeAtIndex(0)
            
            if(dealer.score > 21){
                dealer.busted = true
                dealerBusted()
            }
        }
    }
    
    func computerPlay() {

        if(!computer.busted){
            computer.hand.cards.append(shoe[0])
            
            computer.score = computer.hand.getscore()
            computerScoreLabel.text = "\(computer.score)"
            var handCount = computer.hand.cards.count
            if(handCount == 0) {
                computerCard1.image = shoe[0].cardImage
            }
            else if(handCount == 1) {
                computerCard2.image = shoe[0].cardImage
            }
            else if(handCount == 2) {
                computerCard3.image = shoe[0].cardImage
            }
            else if(handCount == 3) {
                computerCard4.image = shoe[0].cardImage
            }
            else if(handCount == 4) {
                computerCard5.image = shoe[0].cardImage
            }
            else if(handCount == 5) {
                computerCard6.image = shoe[0].cardImage
            }
            shoe.removeAtIndex(0)

            
            if(computer.score > 21){
                computer.busted = true
                
                lastDealerPlay(nil)
            }
        }
        
    }
    
    func computerLastPlay(alert: UIAlertAction!) {
        while(computer.score <= 16) {
           computerPlay()
        }
        lastDealerPlay(nil)
    }
    
    
    func playerPlay() {
        player.hand.cards.append(shoe[0])
        
       
        player.score = player.hand.getscore()
        playerScoreLabel.text = "\(player.score)"
        var handCount = player.hand.cards.count
        if(handCount == 0) {
            playerCard1.image = shoe[0].cardImage
        }
        else if(handCount == 1) {
            playerCard2.image = shoe[0].cardImage
        }
        else if(handCount == 2) {
            playerCard3.image = shoe[0].cardImage
        }
        else if(handCount == 3) {
            playerCard4.image = shoe[0].cardImage
        }
        else if(handCount == 4) {
            playerCard5.image = shoe[0].cardImage
        }
        else if(handCount == 5) {
            playerCard6.image = shoe[0].cardImage
        }
        shoe.removeAtIndex(0)

        if(player.score > 21){
            player.busted = true
            player.balance = player.balance - betAmount
            var placeBetAlert = UIAlertController(title: " BUSTED ! " ,message: "Human Player Busted !",preferredStyle:UIAlertControllerStyle.Alert)
            placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: computerLastPlay))
            presentViewController(placeBetAlert, animated: true, completion: nil)
          
        }
        
        
 
        
    }

    
    
    func lastDealerPlay(alert: UIAlertAction!) {
        
        
        if(player.busted && computer.busted)
        {
            var placeBetAlert = UIAlertController(title: "Dealer wins" ,message: "Both Players Busted !",preferredStyle:UIAlertControllerStyle.Alert)
            placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: reset))
            presentViewController(placeBetAlert, animated: true, completion: nil)
            
        }
        else
        {
            while(dealer.score<16)
            {
                dealerPlay()
            }
            
            
                if(!player.busted && dealer.score < player.score && !playerBlackJack) {
                    player.balance = player.balance + 2 * player.betAmount
                  
                        var placeBetAlert = UIAlertController(title: "Game Over" ,message: "Human player beats dealer",preferredStyle:UIAlertControllerStyle.Alert)
                        placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: reset))
                        presentViewController(placeBetAlert, animated: true, completion: nil)
                }
                else if(!player.busted && dealer.score == player.score && !playerBlackJack) {
                   
                    player.balance = player.balance + player.betAmount
                   
                    var placeBetAlert = UIAlertController(title: "Game Over" ,message: "Human player ties with dealer",preferredStyle:UIAlertControllerStyle.Alert)
                    placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: reset))
                    presentViewController(placeBetAlert, animated: true, completion: nil)
                }
            else if(!playerBlackJack && !player.busted && dealer.score > player.score )
                {
                    var placeBetAlert = UIAlertController(title: "Game Over" ,message: "Human player loses.",preferredStyle:UIAlertControllerStyle.Alert)
                    placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: reset))
                    presentViewController(placeBetAlert, animated: true, completion: nil)
            }
            
            
            if(!computer.busted && dealer.score < computer.score) {
              
                var placeBetAlert = UIAlertController(title: "Game Over" ,message: "Computer player beats dealer",preferredStyle:UIAlertControllerStyle.Alert)
                placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: reset))
                presentViewController(placeBetAlert, animated: true, completion: nil)
            }
            else if(!computer.busted && dealer.score == computer.score) {
                var placeBetAlert = UIAlertController(title: "Game Over" ,message: "Computer player ties with dealer",preferredStyle:UIAlertControllerStyle.Alert)
                placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: reset))
                presentViewController(placeBetAlert, animated: true, completion: nil)
            }
            else
            {
                var placeBetAlert = UIAlertController(title: "Game Over" ,message: "Computer player loses",preferredStyle:UIAlertControllerStyle.Alert)
                placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: reset))
                presentViewController(placeBetAlert, animated: true, completion: nil)
            }

            
            
            
    }
    }
    
    
    
    func dealerBusted() {
        var placeBetAlert = UIAlertController(title: "Busted" ,message: "Dealer Busted !",preferredStyle:UIAlertControllerStyle.Alert)
        placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: reset))
        presentViewController(placeBetAlert, animated: true, completion: nil)
        
            if( !player.busted) {
                player.balance = player.balance + 2 * player.betAmount
        }
    }
    
    
    
   
    
    
    
    @IBAction func hitClicked(sender: AnyObject) {
        if (enableHitStand) {
        playerPlay()
        }
    }
    
    
    
    
    @IBAction func standClicked(sender: AnyObject) {
        if (enableHitStand) {
        computerLastPlay(nil)
        }
    }
    
    func zeroBalance(alert: UIAlertAction!) {
        player.balance = 100
        balanceLabel.text = "\(100)"
    }
    
    func reset(alert: UIAlertAction!) {
        balanceLabel.text = "\(player.balance)"
        computerScoreLabel.text = "0"
        playerScoreLabel.text = "0"
        
         playerCard1.image = nil
         playerCard2.image = nil
         playerCard3.image = nil
         playerCard4.image = nil
         playerCard5.image = nil
         playerCard6.image = nil
        
        
         dealerCard1.image = nil
         dealerCard2.image = nil
         dealerCard3.image = nil
         dealerCard4.image = nil
         dealerCard5.image = nil
         dealerCard6.image = nil
        
        
         computerCard1.image = nil
         computerCard2.image = nil
         computerCard3.image = nil
         computerCard4.image = nil
         computerCard5.image = nil
         computerCard6.image = nil
        
         betAmountLabel.text = "0"
        betAmount = 0
        player.betAmount = 0
        player.hand.cards.removeAll()
        computer.hand.cards.removeAll()
        dealer.hand.cards.removeAll()
        player.busted = false
        computer.busted = false
        dealer.busted = false
        
        player.score = 0
        dealer.score = 0
        computer.score = 0
        enableHitStand = false
        if(player.balance <= 0) {
            var placeBetAlert = UIAlertController(title: "Zero Balance" ,message: "Restarting the game ! ",preferredStyle:UIAlertControllerStyle.Alert)
            placeBetAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: zeroBalance))
            presentViewController(placeBetAlert, animated: true, completion: nil)
            

            
        }
        
    }

    
    
}

