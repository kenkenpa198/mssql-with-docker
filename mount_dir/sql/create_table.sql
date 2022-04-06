CREATE TABLE members (
    member_id int not null primary key,
    first_name nvarchar(50),
    last_name nvarchar(50),
    created_at datetime not null,
    updated_at datetime
)
;
