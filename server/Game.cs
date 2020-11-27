using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace KittyRpg
{
    //Player class. each player that join the game will have these attributes.
    public class Player : BasePlayer
    {
        public Boolean IsReady = true;
    }

    [RoomType("KittyRpg2")]
    public class GameCode : Game<Player>
    {
        //Ok, basically we just want to keep a list of players on the server.
        //When someone joins, they're added to the list.
        //When they leave, they're marked as blank
        //If another player joins, they're assigned a player position from the first empty spot
        private String[] playernames = new String[100];
        private Boolean[] playeronline = new Boolean[100];
        private int[] playerids = new int[100];
        private int[] playerisdog = new int[100];
        private int numplayers;
        private int[] reverseplayerids = new int[1000];

        public override bool AllowUserJoin(Player player)
        {
            if (PlayerCount + 1 > 10) //can only have a maximum of 2 players, after that they are denied to join
            {
                Console.WriteLine("AllowUserJoin returned false ->room is full");
                return false;
            }
            return true;
        }

        // This method is called when an instance of your the game is created
        public override void GameStarted()
        {
            // anything you write to the Console will show up in the 
            // output window of the development server
            Console.WriteLine("Game is started");
            for (int i = 0; i < 100; i++)
            {
                playernames[i] = "";
                playeronline[i] = false;
                playerids[i] = -1;
                playerisdog[i] = 0;
            }
            numplayers = 0;
        }

        // This method is called when the last player leaves the room, and it's closed down.
        public override void GameClosed()
        {
            Console.WriteLine("RoomId: " + RoomId);
        }

        // This method is called whenever a player joins the game
        public override void UserJoined(Player player)
        {

            joinGame(player);


            //Send info about all already connected users to the newly joined users chat
            Message m = Message.Create("ChatInit");
            m.Add(player.Id);

            foreach (Player p in Players)
            {
                m.Add(p.Id, p.ConnectUserId);
            }

            player.Send(m);

            //Informs other users chats that a new user just joined.
            Broadcast("ChatJoin", player.Id, player.ConnectUserId);
        }

        // This method is called when a player leaves the game
        public override void UserLeft(Player player)
        {
            //Ok, locate this player in the playerlist:
            int firstplayer = -1;
            for (int i = 0; i < numplayers; i++)
            {
                if (firstplayer == -1)
                {
                    if (playerids[i]==player.Id)
                    {
                        firstplayer = i; //Found them!
                    }
                }
            }
            if (firstplayer == -1)
            {
                //Er, ok, they're not in the list. Do nothing, I guess?
            }
            else
            {
                //Tell the chat that the player left.
                Broadcast("ChatLeft", reverseplayerids[playerids[firstplayer]]);

                //update our own list
                playernames[reverseplayerids[playerids[firstplayer]]] = "";
                playeronline[reverseplayerids[playerids[firstplayer]]] = false;
                playerisdog[reverseplayerids[playerids[firstplayer]]] = 0;
                playerids[reverseplayerids[playerids[firstplayer]]] = -1;
                

                //Is that the last playernum? If so, we reduce the list size
                if (firstplayer == numplayers) numplayers--;

                createreversetable();
                if (numplayers == 0)
                {
                    //All players have now left - destroy the room
                }
            }

            //	Console.WriteLine("User left the chat " + player.Id);

            /*
            if (player == player1)
            {
                player1 = null;
            }
            else if (player == player2)
            {5
                player2 = null;
            }
            else
                return;

            Broadcast("left", player1 != null ? player1.ConnectUserId : "", player2 != null ? player2.ConnectUserId : "");
             * */


        }

        private void createreversetable()
        {
            for (int i = 0; i < numplayers; i++)
            {
                if(playerids[i]>-1){
                    reverseplayerids[playerids[i]] = i;
                }
            }
        }

        private void joinGame(Player user)
        {
            //Alright, look for the first empty spot and assign the player that value
            int firstplayer = -1;
            for (int i = 0; i < 100; i++)
            {
                if (firstplayer == -1)
                {
                    if (!playeronline[i])
                    {
                        firstplayer = i;
                    }
                }
            }
            //Either this player takes up an old slot, or a new one, if new, adjust playernumbers
            if (firstplayer >= numplayers) numplayers = firstplayer + 1;
            playeronline[firstplayer] = true;
            playernames[firstplayer] = "";
            playerids[firstplayer] = user.Id;
            playerisdog[firstplayer] = 0;
            createreversetable();

            user.Send("init", firstplayer, user.ConnectUserId);
        }

        // This method is called when a player sends a message into the server code
        public override void GotMessage(Player player, Message message)
        {
            switch (message.Type)
            {
                case "reset":
                    {
                        /*if (player1 != null && player2 != null)
                        {
                            player.IsReady = true;
                            if (player1.IsReady && player2.IsReady)
                            {
                                resetGame(null);
                            }
                        }
                         */
                        break;
                    }
                case "join":
                    {
                        joinGame(player);
                        break;
                    }

                case "sendgs":
                    {
                        //Broadcast info about all already connected users to the clients
                        Message m = Message.Create("getgs");
                        m.Add(numplayers);
                        for (int i = 0; i < numplayers; i++)
                        {
                            m.Add(playernames[i]);
                            if (playeronline[i])
                            {
                                m.Add(1);
                            }
                            else
                            {
                                m.Add(0);
                            }
                            if (playerisdog[i] == 1)
                            {
                                m.Add(1);
                            }
                            else
                            {
                                m.Add(0);
                            }
                        }
                        Broadcast(m);
                        break; 
                    }


                case "chatjoin2":
                    {
                        //We update our own database here
                        int firstplayer = -1;
                        for (int i = 0; i < numplayers; i++)
                        {
                            if (firstplayer == -1)
                            {
                                if (playerids[i]==player.Id)
                                {
                                    firstplayer = i; //Found them!
                                }
                            }
                        }
                        if (firstplayer == -1)
                        {
                            //Er, ok, they're not in the list. Do nothing, I guess?
                        }
                        else
                        {
                            playernames[firstplayer] = message.GetString(0);
                            Broadcast("chatjoin3", player.Id, message.GetString(0), firstplayer);

                            //Broadcast info about all already connected users to the clients
                            Message m = Message.Create("gamestate");
                            m.Add(numplayers);
                            for (int i = 0; i < numplayers; i++)
                            {
                                m.Add(playernames[i]);
                                if (playeronline[i])
                                {
                                    m.Add(1);
                                }
                                else
                                {
                                    m.Add(0);
                                }
                                if (playerisdog[i]==1)
                                {
                                    m.Add(1);
                                }
                                else
                                {
                                    m.Add(0);
                                }
                            }
                            Broadcast(m);
                            
                            /*m.Add(player.Id);

                            foreach (Player p in Players)
                            {
                                m.Add(p.Id, p.ConnectUserId);
                            }
                             * */
                        }
                        break;
                    }


                case "becomedog":
                    {
                        Broadcast("becomedog", player.Id, message.GetInteger(1));
                        playerisdog[message.GetInteger(1)] = 1;
                        break;
                    }


                case "cursedog":
                    {
                        Broadcast("cursedog", player.Id, message.GetInteger(1));
                        playerisdog[message.GetInteger(1)] = 1;
                        break;
                    }

                case "becomecat":
                    {
                        Broadcast("becomecat", player.Id, message.GetInteger(1));
                        playerisdog[message.GetInteger(1)] = 0;
                        break;
                    }

                case "m":
                    {
                        Broadcast("m", reverseplayerids[player.Id], message.GetString(0), message.GetInteger(2), message.GetInteger(3), message.GetInteger(4));
                        break;
                    }

                case "hair":
                    {
                        Broadcast("hair", player.Id, message.GetString(0), message.GetInteger(2), message.GetInteger(3));
                        break;
                    }

                case "foundmouse":
                    {
                        Broadcast("foundmouse", player.Id, message.GetInteger(0), message.GetInteger(1));
                        break;
                    }

                case "showmouse":
                    {
                        Broadcast("showmouse", player.Id, message.GetInteger(0));
                        break;
                    }

                case "kill":
                    {
                        Broadcast("kill", player.Id, message.GetInteger(1));
                        break;
                    }
                case "nyan1":
                    {
                        Broadcast("nyan1", player.Id, message.GetString(0));
                        break;
                    }

                case "nyan2":
                    {
                        Broadcast("nyan2", player.Id, message.GetString(0));
                        break;
                    }
                case "opendoor":
                    {
                        Broadcast("opendoor", player.Id, message.GetString(0), message.GetInteger(1));
                        break;
                    }

                case "closedoor":
                    {
                        Broadcast("closedoor", player.Id, message.GetString(0), message.GetInteger(1));
                        break;
                    }

                case "damage1":
                    {
                        Broadcast("damage1", player.Id, message.GetString(0), message.GetInteger(1), message.GetInteger(2), message.GetInteger(3));
                        break;
                    }

                case "damage2":
                    {
                        Broadcast("damage2", player.Id, message.GetString(0), message.GetInteger(1), message.GetInteger(2), message.GetInteger(3));
                        break;
                    }
                case "hairdamage1":
                    {
                        Broadcast("hairdamage1", player.Id, message.GetString(0), message.GetInteger(1), message.GetInteger(2), message.GetInteger(3));
                        break;
                    }

                case "hairdamage2":
                    {
                        Broadcast("hairdamage2", player.Id, message.GetString(0), message.GetInteger(1), message.GetInteger(2), message.GetInteger(3));
                        break;
                    }
                case "c":
                    {
                        Broadcast("c", player.Id, message.GetInteger(0), message.GetString(1), message.GetString(2));
                        break;
                    }

                case "chat1":
                    {
                        Broadcast("chat1", player.Id, message.GetInteger(0), message.GetString(1), message.GetString(2));
                        break;
                    }

                case "chat2":
                    {
                        Broadcast("chat2", player.Id, message.GetInteger(0), message.GetString(1), message.GetString(2));
                        break;
                    }

                case "chat3":
                    {
                        Broadcast("chat3", player.Id, message.GetInteger(0), message.GetString(1), message.GetString(2));
                        break;
                    }

                case "chat4":
                    {
                        Broadcast("chat4", player.Id, message.GetInteger(0), message.GetString(1), message.GetString(2));
                        break;
                    }

                case "d":
                    {
                        Broadcast("d", player.Id, message.GetInteger(0), message.GetString(1), message.GetString(2));
                        break;
                    }
            }
        }

        private void resetGame(Player user)
        {
            /*
             * player1.IsReady = false;
            player2.IsReady = false;
            if (user != null)
                user.Send("reset", player1 == hasTurn ? 0 : 1);
            Broadcast("reset", player1 == hasTurn ? 0 : 1);
             */
        }
    }
}