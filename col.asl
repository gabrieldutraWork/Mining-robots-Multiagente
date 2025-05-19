// Beliefs

pos(boss,15,15).
checking_cells.
resource_needed(1).
resource_id(0).
found_resources([]).

// Plans

+my_pos(X,Y)   
   :  checking_cells & not building_finished
   <- .drop_all_desires;
      !check_for_resources.
   
+!check_for_resources
   :  resource_needed(R) & not found(R) & my_pos(X,Y) & group_found(R, X, Y, ID)
   <- !no_resource(R, X, Y, ID);
      .broadcast(achieve, no_resource(R, X, Y, ID));
      +checking_cells;
      .drop_all_desires;
      !check_for_resources.
	  
+!check_for_resources
   :  resource_needed(R) & group_found(R, X, Y, ID)
   <- .findall([ID, R, A, B], group_found(R, A, B, ID), Resource_List);
      .sort(Resource_List, Sorted);
      .nth(0, Sorted, First);
      .nth(2, First, X1);
      .nth(3, First, Y1);
      !mine_update(X1, Y1);
      .drop_all_desires;
      !check_for_resources.

+!check_for_resources
   :  resource_needed(R) & found(R)
   <- !update_resource(R);
      .drop_all_desires;
      !check_for_resources.
     
+!check_for_resources
   :  resource_needed(R) & not found(R) & pos(last_searched, X, Y)
   <- !go(last_searched);
      -pos(last_searched, X, Y);
      .drop_all_desires;
      !check_for_resources.
	  
+!check_for_resources
   : found(R) & not resource_needed(R)
   <- !update_resource(R);
      .drop_all_desires;
      .wait(50);
      move_to(next_cell).
	  
+!check_for_resources
   :  resource_needed(R) & not found(R)
   <- +checking_cells;
      .wait(50);
      move_to(next_cell).
		 
+!update_resource(R)
   :  true
   <- ?my_pos(X,Y);
      ?resource_id(ID);
      ID_new = ID + 1;
      -resource_id(ID);
      +resource_id(ID_new);
      +group_found(R, X, Y, ID);
      ?found_resources(ResList);
      ResList_new = [[ID, R, X, Y] | ResList];
      -found_resources(ResList);
      +found_resources(ResList_new);
      .broadcast(tell, group_found(R, X, Y, ID)).

+!mine_update(X, Y)
   : true
   <- ?my_pos(X1, Y1);
      +pos(last_searched, X1, Y1);
      !dont_check(X, Y); 
      !go(current_resource);
      !take(R, boss); 
      !continue_mine. 

+!dont_check(X, Y) : true
   <- +pos(current_resource,X,Y);
      -checking_cells.

+!take(R,B) : true
   <- .wait(50);
      mine(R);
      !go(B);
      drop(R).

+!continue_mine : pos(current_resource, X, Y)
   <- !go(current_resource);
      -pos(current_resource,X,Y);
      +checking_cells.
	  
+!continue_mine : true
   <- .drop_all_desires;
      !check_for_resources.
	  
+!no_resource(R, X, Y, ID) : true
   <- .abolish(group_found(R, X, Y, ID));
      .abolish(pos(current_resource, X, Y));
      ?found_resources(ResList);
      ResList_new = .delete(ResList, [ID, R, X, Y]);
      -found_resources(ResList);
      +found_resources(ResList_new).

+!go(Position)
   : pos(Position, X, Y) & my_pos(X, Y)
   <- .drop_all_desires;
      true.

+!go(Position)
   : Position == current_resource & not pos(current_resource, X, Y) & pos(last_searched, X1, Y1) & group_found(R, X2, Y2, ID) & resource_needed(R)
   <- !clear_last_searched(X1, Y1);
      !check_for_resources.

+!go(Position)
   : Position == current_resource & not pos(current_resource, X, Y) & pos(last_searched, X1, Y1)
   <- !return_to_last_searched(X1, Y1);
      !check_for_resources.

+!go(Position)
   : true
   <- ?pos(Position, X, Y);
      .wait(50);
      move_towards(X, Y);
      !go(Position).

+!clear_last_searched(X1, Y1) : true
   <- -pos(last_searched, X1, Y1).

+!return_to_last_searched(X1, Y1) : true
   <- !go(last_searched);
      -pos(last_searched, X1, Y1).

@psf[atomic]
+!search_for(NewResource) : resource_needed(OldResource)
   <- +resource_needed(NewResource);
      -resource_needed(OldResource).

@pbf[atomic]
+building_finished : true
   <- .drop_all_desires;
      !go(boss).