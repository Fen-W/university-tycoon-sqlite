
create table IF not exists token (
  token_id integer PRIMARY key,
  token_name text not null unique

  )
  ;

create TABLE if not exists location (
  location_id integer primary key,
  location_type text CHECK (location_type in ('corner','hearing','rag','building')),
  location_name text not null UNIQUE,
  board_position integer not null
);

create table if NOT exists special (
  special_id integer PRIMARY key,
  location_id INTEGER not null unique,
  name text not null unique,
  description text not null,
  special_type text not null check (special_type in ('rag','hearing','corner')),
  foreign key (location_id) REFERENCES location(location_id)
);

create table if not EXISTS player (
  player_id integer primary key,
  token_id integer not null UNIQUE,
  current_location integer not null,
  name text NOT null unique,
  credits integer not null check (credits >= 0),
  status text not null default 'active' CHECK (status in ('active','suspended','visiting')),
  foreign key (token_id) REFERENCES token(token_id),
  foreign key (current_location) references location(location_id)
);

create table if not exists building (
  building_id integer primary key,
  location_id integer NOT null unique,
  name text not null unique,
  owner_id integer,
  tuition_fee integer NOT null check (tuition_fee >= 0),
  colour_group text not null,
  foreign key (location_id) REFERENCES location(location_id),
  foreign key (owner_id) references player(player_id)
);

create table IF not exists audit_log (
  audit_id integer primary key AUTOINCREMENT,
  landed_location integer not null,
  player_id integer not null,
  round_number integer NOT null,
  turn_number integer not null,
  credit_balance integer not null check (credit_balance >= 0),
  roll integer NOT null check (roll between 0 and 6),-- was 1-6 but at inital statate of the game its 0 so its not chagned to not negitive 
  foreign key (landed_location) REFERENCES location(location_id),
  foreign key (player_id) references player(player_id)
);
create table if not exists input (
    turn_id integer PRIMARY KEY AUTOINCREMENT, -- or just a single row system
    player_id integer,
    dice_roll integer CHECK (dice_roll between 1 and 6),
    FOREIGN KEY (player_id) REFERENCEs player(player_id)
);


create TRIGGER move AFTER insert ON input
for EACH row BEGIN
  update player set
    current_location = case
      when status= 'suspended' and new.dice_roll <>6 then current_location
      ELSE ((current_location +new.dice_roll -1)%  20) +1
    end,
    status= case
      when status  = 'suspended' AND new.dice_roll= 6 then 'active'
      when status='suspended' and new.dice_roll !=6 then 'suspended'
      else 'active'
    end
  where player_id =new.player_id;


END;
create TRIGGER audit AFTER insert ON input
for EACH row BEGIN
  insert into audit_log (player_id , landed_location, round_number, turn_number, credit_balance, roll)
  values (
      new.player_id, 
      (select current_location from player where player_id= new.player_id),
      (select count(*) from audit_log where player_id=new.player_id and roll NOT IN (0, 6)) + 1,
      (select count(*)+ 1 from audit_log),
      (select credits from player where player_id =new.player_id), 
      new.dice_roll
  );
END;

create trigger welcome_week after UPDATE of current_location ON player
for each ROW when new.current_location < old.current_location AND new.current_location<>  8
BEGIN
  update player set credits =credits+ 100 where player_id= new.player_id;
END;

create TRIGGER suspension AFTER update of current_location on player
for each row when new.current_location =18 BEGIN
  update player set status='suspended' , current_location=  8 where player_id =new.player_id;
END;

create trigger visiting after UPDATE of current_location on player
for EACH row when new.current_location= 8 AND new.status != 'suspended' and old.current_location <>18
begin
  update player set status= 'visiting' where player_id= new.player_id;
end;

create TRIGGER auto_buy_property after update of current_location ON player for each row
BEGIN
  update player set credits= credits - (select tuition_fee *2 from building where location_id= new.current_location)
  where player_id= new.player_id
  and exists (select 1 from building where location_id =new.current_location and owner_id is  NULL)
  and (select dice_roll from input order by turn_id DESC limit 1) <>6;

  update building set owner_id= new.player_id
  where location_id =new.current_location and owner_id IS null
  and (select dice_roll from input order by turn_id desc limit 1)!= 6;
END;

create trigger special AFTER update of current_location on player for EACH row
BEGIN
  update player set credits =credits- 30 where player_id=new.player_id and new.current_location= 4
  and (select dice_roll from input order by turn_id desc limit 1) !=6;

  update player set credits= credits +75 where player_id= new.player_id and new.current_location =7
  and (select dice_roll from input order by turn_id DESC limit 1)<> 6;

  update player set credits=credits -100 where player_id =new.player_id and new.current_location= 17
  and (select dice_roll from input order by turn_id desc limit 1) !=6;

  update player set credits =credits+ 50 WHERE new.current_location=  14
  and (select dice_roll from input order by turn_id desc limit 1)<>  6;
END;

create TRIGGER tuition after UPDATE of current_location on player for each ROW
BEGIN
  update player set credits= credits -(
    select case
      when (select count(*) from building b where b.colour_group=(select colour_group from building where location_id= new.current_location) and b.owner_id= (select owner_id from building where location_id=new.current_location))
         = (select count(*) from building b where b.colour_group= (select colour_group from building where location_id= new.current_location))
      then tuition_fee* 2 else tuition_fee
    end
    from building where location_id =new.current_location
  )
  where player_id= new.player_id
  and exists (select 1 from building where location_id=new.current_location and owner_id is NOT null and owner_id!= new.player_id)
  and (select dice_roll from input order by turn_id desc limit 1) <>6;

  update player set credits =credits +(
    select case
      when (select count(*) from building b where b.colour_group =(select colour_group from building where location_id=new.current_location) and b.owner_id= (select owner_id from building where location_id= new.current_location))
         = (select count(*) from building b where b.colour_group=(select colour_group from building where location_id =new.current_location))
      then tuition_fee *2 else tuition_fee
    end
    from building where location_id= new.current_location
  )
  where player_id= (select owner_id from building where location_id=new.current_location)
  and exists (select 1 from building where location_id= new.current_location and owner_id IS NOT null and owner_id <>new.player_id)
  and (select dice_roll from input order by turn_id desc limit 1)!= 6;
END;



