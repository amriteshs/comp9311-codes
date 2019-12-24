-- COMP9311 18s2 Assignment 1
-- Schema for the myPhotos.net photo-sharing site
--
-- Written by:
--    Name:  Amritesh Singh
--    Student ID:  z5211987
--    Date:  02/09/2018
--
-- Conventions:
-- * all entity table names are plural
-- * most entities have an artifical primary key called "id"
-- * foreign keys are named after either:
--   * the relationship they represent
--   * the table being referenced

-- Domains

create domain URLValue as varchar(100) check(value like 'http://%');
create domain EmailValue as	varchar(100) check(value like '%@%.%');
create domain GenderValue as varchar(6) check(value in ('male','female'));
create domain GroupModeValue as	varchar(15) check(value in ('private','by-invitation','by-request'));
create domain ContactListTypeValue as varchar(10) check(value in ('friends','family'));
create domain VisibilityValue as varchar(15) check(value in ('private', 'friends', 'family', 'friends+family', 'public'));
create domain SafetyLevelValue as varchar(12) check(value in ('safe', 'moderate', 'restricted'));
create domain NameValue as varchar(50);
create domain LongNameValue as varchar(100);

-- Tables

create table People (
    id                    serial,
    family_name           NameValue,
    given_names           NameValue not null,
    displayed_name        LongNameValue,
    email_address         EmailValue not null unique,
    primary key(id)
);

create table Users (
    id                    serial,
    "password"            text not null,
    birthday              date,
    gender                GenderValue,
    website               URLValue unique,
    date_registered       date,
    primary key(id),
    foreign key(id) references People(id)
);

create table Contact_lists (
    id                    serial,
    title                 text not null,
    type                  ContactListTypeValue,
    ownedBy               integer not null,
    primary key(id),
    foreign key(ownedBy) references Users(id)
);

create table People_member_Contact_lists (
    person_id             integer,
    contact_list_id       integer,
    primary key(person_id, contact_list_id),
    foreign key(person_id) references People(id),
    foreign key(contact_list_id) references Contact_lists(id)
);

create table Groups (
    id                    serial,
    title                 text not null,
    "mode"                GroupModeValue not null,
    ownedBy               integer not null,
    primary key(id),
    foreign key(ownedBy) references Users(id)
);

create table Users_member_Groups (
    user_id               integer,
    group_id              integer,
    primary key(user_id, group_id),
    foreign key(user_id) references Users(id),
    foreign key(group_id) references Groups(id)
);

create table Photos (
    id                    serial,
    title                 NameValue not null,
    description           text,
    date_taken            date,
    date_uploaded         date not null,
    file_size             integer not null check(file_size > 0),
    visibility            VisibilityValue not null,
    safety_level          SafetyLevelValue not null,
    technical_details     text,
    ownedBy               integer not null,
    primary key(id),
    foreign key(ownedBy) references Users(id)
);

alter table Users add column portrait integer references Photos(id);

create table Users_rates_Photos (
    user_id               integer,
    photo_id              integer,
    rating                integer check(rating between 1 and 5),
    when_rated            timestamp not null,
    primary key(user_id, photo_id),
    foreign key(user_id) references Users(id),
    foreign key(photo_id) references Photos(id)
);

create table Tags (
    id                    serial,
    name                  NameValue not null,
    freq                  integer check(freq >= 0),
    primary key(id)
);

create table Photos_has_Tags (
    user_id               integer,
    photo_id              integer,
    tag_id                integer,
	when_tagged           timestamp not null,
    primary key(user_id, photo_id, tag_id),
    foreign key(user_id) references Users(id),
    foreign key(photo_id) references Photos(id),
    foreign key(tag_id) references Tags(id)
);

create table Collections (
    id                    serial,
    title                 NameValue not null,
    description           text,
    "key"                 integer not null,
    primary key(id),
    foreign key(key) references Photos(id)
);

create table Photos_in_Collections (
    photo_id              integer,
    collection_id         integer,
    "order"               integer not null check("order" > 0),
    primary key(photo_id, collection_id),
    foreign key(photo_id) references Photos(id),
    foreign key(collection_id) references Collections(id)
);

create table User_collections (
    collection_id         integer,
    ownedBy               integer not null,
    primary key(collection_id),
    foreign key(collection_id) references Collections(id),
    foreign key(ownedBy) references Users(id)
);

create table Group_collections (
    collection_id         integer,
    ownedBy               integer not null,
    primary key(collection_id),
    foreign key(collection_id) references Collections(id),
    foreign key(ownedBy) references Groups(id)
);

create table Discussions (
    id                    serial,
    title                 NameValue,
    primary key(id)
);

create table Groups_has_Discussions (
	group_id			  integer,
	discussion_id         integer,
	primary key(group_id, discussion_id),
	foreign key(group_id) references Groups(id),
	foreign key(discussion_id) references Discussions(id)
);

create table Comments (
    id                    serial,
    when_posted           timestamp not null,
    content               text not null,
    containedBy           integer not null,
    authoredBy            integer not null,
    primary key(id),
    foreign key(containedBy) references Discussions(id),
    foreign key(authoredBy) references Users(id)
);
