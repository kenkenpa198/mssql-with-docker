create table members (
    member_id int not null primary key,
    first_name varchar(50) null,
    last_name varchar(50) null,
    created_at datetime not null,
    updated_at datetime null
)
;
