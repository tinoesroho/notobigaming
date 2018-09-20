#define RANK_MINPLAYERS 6

new CURRENT_COUNT;
new DISCONNECT_COUNT;
new NEEDED;

//called everytime a client connect
public OnClientPutInServer(client){
  CURRENT_COUNT = GetClientCount();
  NEEDED = RANK_MINPLAYERS - CURRENT_COUNT;
  if( GetClientCount() == RANK_MINPLAYERS ) {
	PrintToChatAll("Global Ranking is going LIVE.");
  }
  if( GetClientCount() < RANK_MINPLAYERS ){
	PrintToChatAll("Need %i more players for Global Rank.", NEEDED); 
  }
}

public OnClientDisconnect(client){
  DISCONNECT_COUNT = GetClientCount();
  CURRENT_COUNT = DISCONNECT_COUNT - 1;
  NEEDED = RANK_MINPLAYERS - CURRENT_COUNT;
  if( GetClientCount() > RANK_MINPLAYERS ){
	PrintToChatAll("Global Rank still Live. %i of %i players in-game.", CURRENT_COUNT, RANK_MINPLAYERS); 
  }
  if( CURRENT_COUNT == RANK_MINPLAYERS ){
	PrintToChatAll("Global Rank still Live. %i of %i players in-game.", CURRENT_COUNT, RANK_MINPLAYERS); 
  }
  if( GetClientCount() < RANK_MINPLAYERS ){
	PrintToChatAll("Need %i more players for Global Rank.", NEEDED); 
  }
}  